//
//  FTINDraggableItemBoxView.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINDraggableItemBoxView.h"
#import "FTINCollectionViewCell.h"
#import "FTINEnvironmentSubActivityContent.h"

#import "DNDDragAndDrop.h"

CGFloat const FTINDraggableItemBoxViewToolSpacing = 8.f;
CGFloat const FTINDraggableItemBoxViewDragOpacity = 1.;
CGFloat const FTINDraggableItemBoxCellCornerRadius = 5.f;
CGFloat const FTINDraggableItemBoxSelectionBorderWidth = 3.f;

#define FTINDraggableItemBoxSelectionBorderColor [UIColor colorWithRed:6.f/255.f green:134.f/255.f blue:1.f alpha:1]

@interface FTINDraggableItemBoxView () <DNDDragSourceDelegate, DNDDropTargetDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
	CGSize _toolSize;
	DNDDragAndDropController *_dragDropController;
	NSMutableArray *_unchosenElements;
	NSMutableDictionary *_chosenElements;
	NSMutableSet *_chosenElementsViews;
}

@property (weak, nonatomic) IBOutlet UICollectionView *toolboxCollectionView;
@property (weak, nonatomic) IBOutlet UIView *containerBox;

- (FTINCollectionViewCell *)createCellOrCopyFrom:(FTINCollectionViewCell *)cell;
- (void)removeSelectedElement:(UITapGestureRecognizer *)gestureRecognizer;
- (void)removeView:(UIView *)view animated:(BOOL)animated;

@end

@implementation FTINDraggableItemBoxView

#pragma mark - Super methods

- (void)dealloc
{
	[self setToolboxElements:nil];
	_unchosenElements = nil;
	_chosenElements = nil;
	_chosenElementsViews = nil;
	_dragDropController = nil;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSArray *loaded = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
		UIView *view = loaded[0];
		view.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
		[self addSubview:view];
		
		[self.toolboxCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FTINCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[FTINCollectionViewCell cellIdentifier]];
		[self.toolboxCollectionView registerClass:[FTINCollectionViewCell class] forCellWithReuseIdentifier:[FTINCollectionViewCell cellIdentifier]];
		
		_dragDropController = [[DNDDragAndDropController alloc] init];
		[_dragDropController registerDropTarget:self.containerBox withDelegate:self];
		[_dragDropController registerDropTarget:self.toolboxCollectionView withDelegate:self];
		
		_unchosenElements = [NSMutableArray array];
		_chosenElements = [NSMutableDictionary dictionary];
		_chosenElementsViews = [NSMutableSet set];
    }
    return self;
}

#pragma mark - Instance methods

- (void)setToolboxElements:(NSArray *)toolboxElements
{
	_toolboxElements = toolboxElements;
	
	for (UIView *view in _chosenElementsViews)
	{
		[view removeFromSuperview];
	}
	
	[_chosenElementsViews removeAllObjects];
	[_chosenElements removeAllObjects];
	[_unchosenElements removeAllObjects];
	[_unchosenElements addObjectsFromArray:toolboxElements];
		
	NSUInteger count = toolboxElements.count;
	CGFloat width = floorf((self.toolboxCollectionView.frame.size.width - (count + 1) * FTINDraggableItemBoxViewToolSpacing) / count - 1.f);
	_toolSize = CGSizeMake(width, self.toolboxCollectionView.frame.size.height - 2 * FTINDraggableItemBoxViewToolSpacing);
	self.toolboxCollectionView.contentInset = UIEdgeInsetsMake(FTINDraggableItemBoxViewToolSpacing, 0, FTINDraggableItemBoxViewToolSpacing, 0);
	
	[self.toolboxCollectionView reloadData];
}

- (NSSet *)unchosenElements
{
	return [NSSet setWithArray:_unchosenElements];
}

- (NSSet *)chosenElements
{
	return [NSSet setWithArray:_chosenElements.allValues];
}

- (void)setChosenElements:(NSSet *)chosenElements
{
	[self reset:NO];
	
	CGRect cellFrame = CGRectMake(10, 10, _toolSize.width, _toolSize.height);
	
	for (FTINEnvironmentElement *element in chosenElements)
	{
		FTINCollectionViewCell *cell = [self createCellOrCopyFrom:nil];
		cell.frame = cellFrame;
		cell.backgroundImageView.image = [UIImage lssb_imageNamed:element.imageName];
		cell.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
		cell.backgroundColor = [UIColor whiteColor];
		[cell setBorder:[UIColor blackColor]];
		[cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelectedElement:)]];
		
		[self.containerBox addSubview:cell];
		[_dragDropController registerDragSource:cell withDelegate:self];
		
		[_unchosenElements removeObject:element];
		[_chosenElements setObject:element forKey:@(cell.hash)];
		[_chosenElementsViews addObject:cell];
		
		cellFrame.origin.x += cellFrame.size.width + 10;
	}
	
	[self.toolboxCollectionView reloadData];
}

- (void)reset:(BOOL)animated
{
	for (UIView *view in _chosenElementsViews)
	{
		[self removeView:view animated:animated];
	}
}

- (void)removeSelectedElement:(UITapGestureRecognizer *)gestureRecognizer
{
	[self removeView:gestureRecognizer.view animated:YES];
}

- (void)removeView:(UIView *)view animated:(BOOL)animated
{
	FTINEnvironmentElement *element = _chosenElements[@(view.hash)];
	[_chosenElements removeObjectForKey:@(view.hash)];
	[_unchosenElements addObject:element];
	
	[self.toolboxCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:(_unchosenElements.count - 1) inSection:0]]];
	
	if(animated)
	{
		[UIView animateWithDuration:FTINDefaultAnimationDuration animations:^{
			view.layer.opacity = 0.f;
		} completion:^(BOOL finished) {
			[view removeFromSuperview];
			[_chosenElementsViews removeObject:view];
		}];
	}
	else
	{
		view.layer.opacity = 0.f;
		[view removeFromSuperview];
		[_chosenElementsViews removeObject:view];
	}
}

- (FTINCollectionViewCell *)createCellOrCopyFrom:(FTINCollectionViewCell *)cell
{
	FTINCollectionViewCell *copy;
	
	if(cell)
	{
		copy = [cell copy];
	}
	else
	{
		copy = [[FTINCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, _toolSize.width, _toolSize.height)];
	}
    
	copy.layer.cornerRadius = FTINDraggableItemBoxCellCornerRadius;
	copy.layer.masksToBounds = YES;
	copy.clipsToBounds = YES;
	return copy;
}

#pragma mark - Drag Source Delegate

- (UIView *)draggingViewForDragOperation:(DNDDragOperation *)operation
{
	FTINCollectionViewCell *copy = [self createCellOrCopyFrom:(id)operation.dragSourceView];
	copy.layer.opacity = 0.f;
	
	CGRect frame = copy.frame;
	frame.size = copy.backgroundImageView.image.size;
	copy.frame = frame;
	
	[UIView animateWithDuration:FTINDefaultAnimationShortDuration animations:^{
		operation.dragSourceView.layer.opacity = 0.f;
		copy.layer.opacity = FTINDraggableItemBoxViewDragOpacity;
	}];
	
	return copy;
}

- (void)dragOperationWillCancel:(DNDDragOperation *)operation
{
    [operation removeDraggingViewAnimatedWithDuration:FTINDefaultAnimationDuration animations:^(UIView *dv) {
		CGPoint location = operation.dragSourceView.center;
		location.y += operation.dragSourceView.frame.size.height / 2.f;
		
        dv.alpha = 0.0f;
        dv.center = location;
		
		operation.dragSourceView.layer.opacity = 1.f;
    }];
}

#pragma mark - Drag Target Delegate

- (void)dragOperation:(DNDDragOperation *)operation didDropInDropTarget:(UIView *)target
{
	[target removeBorder];
	
	if(target == self.toolboxCollectionView)
	{
		if(target != operation.dragSourceView.superview)
		{
			[self removeView:operation.dragSourceView animated:YES];
			
			// Luiz: Gambimilambi para não vazar memória.
			[_dragDropController performSelector:@selector(unregisterDragSource:) withObject:operation.dragSourceView afterDelay:.4];
		}
		else
		{
			[UIView animateWithDuration:FTINDefaultAnimationShortDuration animations:^{
				operation.draggingView.layer.opacity = 0.f;
				operation.dragSourceView.layer.opacity = 1.f;
			}];
		}
	}
	else
	{
		UIView *finalView;
		
		if(operation.dragSourceView.superview != target)
		{
			finalView = [self createCellOrCopyFrom:(id)operation.draggingView];
			[finalView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelectedElement:)]];
			
			[target addSubview:finalView];
			[_dragDropController registerDragSource:finalView withDelegate:self];
						
			FTINEnvironmentElement *element = _unchosenElements[finalView.tag];
			[_unchosenElements removeObjectAtIndex:finalView.tag];
			[_chosenElements setObject:element forKey:@(finalView.hash)];
			[_chosenElementsViews addObject:finalView];
			[self.toolboxCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:finalView.tag inSection:0]]];
			
			// Luiz: Gambibambi, pois UICollectionView não atualiza as células.
			self.toolboxCollectionView.userInteractionEnabled = NO;
			[self.toolboxCollectionView performSelector:@selector(reloadData) withObject:nil afterDelay:.4];
		}
		else
		{
			finalView = operation.dragSourceView;
			finalView.layer.opacity = 1.f;
		}
		
		CGRect copyFrame = operation.draggingView.frame;
		copyFrame.origin = [operation locationInView:target];
		copyFrame.origin.x -= copyFrame.size.width / 2.f;
		copyFrame.origin.y -= copyFrame.size.height / 2.f;
		finalView.frame = copyFrame;
		[finalView setLocationInsideSuperview:YES];
	}
}

- (void)dragOperation:(DNDDragOperation *)operation didEnterDropTarget:(UIView *)target
{
	if(operation.dragSourceView.superview != target)
	{
		[target setBorder:FTINDraggableItemBoxSelectionBorderColor withWidth:FTINDraggableItemBoxSelectionBorderWidth];
	}
}

- (void)dragOperation:(DNDDragOperation *)operation didLeaveDropTarget:(UIView *)target
{
	[target removeBorder];
}

#pragma mark - Collection View Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	self.toolboxCollectionView.userInteractionEnabled = YES;
	return self.toolboxElements.count - _chosenElements.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return _toolSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FTINEnvironmentElement *element = _unchosenElements[indexPath.row];
	FTINCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FTINCollectionViewCell cellIdentifier] forIndexPath:indexPath];
	cell.backgroundImageView.image = [UIImage lssb_imageNamed:element.imageName];
	cell.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
	cell.tag = indexPath.row;
	
	[_dragDropController registerDragSource:cell withDelegate:self];
	
	return cell;
}

@end
