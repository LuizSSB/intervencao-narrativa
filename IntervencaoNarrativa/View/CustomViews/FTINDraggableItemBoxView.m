//
//  FTINDraggableItemBoxView.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINDraggableItemBoxView.h"
#import "DNDDragAndDrop.h"
#import "FTINCollectionViewCell.h"

CGFloat const FTINDraggableItemBoxViewToolSpacing = 8.f;
CGFloat const FTINDraggableItemBoxViewDragOpacity = .75f;
CGFloat const FTINDraggableItemBoxCellCornerRadius = 5.f;
CGFloat const FTINDraggableItemBoxSelectionBorderWidth = 3.f;
#define FTINDraggableItemBoxSelectionBorderColor [UIColor colorWithRed:6.f/255.f green:134.f/255.f blue:1.f alpha:1]

@interface FTINDraggableItemBoxView () <DNDDragSourceDelegate, DNDDropTargetDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
	CGSize _toolSize;
	DNDDragAndDropController *_dragDropController;
	NSMutableArray *_unchosenElementsImagesNames;
	NSMutableDictionary *_chosenElementsImagesNames;
	NSMutableSet *_chosenElementsViews;
}

@property (weak, nonatomic) IBOutlet UICollectionView *toolboxCollectionView;
@property (weak, nonatomic) IBOutlet UIView *containerBox;

- (FTINCollectionViewCell *)copyCell:(FTINCollectionViewCell *)cell;
- (void)removeSelectedElement:(UITapGestureRecognizer *)gestureRecognizer;

@end

@implementation FTINDraggableItemBoxView

#pragma mark - Super methods

- (void)dealloc
{
	[self setToolboxElementsImagesNames:nil];
	_unchosenElementsImagesNames = nil;
	_chosenElementsImagesNames = nil;
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
		
		_unchosenElementsImagesNames = [NSMutableArray array];
		_chosenElementsImagesNames = [NSMutableDictionary dictionary];
		_chosenElementsViews = [NSMutableSet set];
    }
    return self;
}

#pragma mark - Instance methods

- (void)setToolboxElementsImagesNames:(NSArray *)toolboxElementsImages
{
	_toolboxElementsImagesNames = toolboxElementsImages;
	
	for (UIView *view in [NSSet setWithSet:_chosenElementsViews])
	{
		[view removeFromSuperview];
	}
	
	[_chosenElementsViews removeAllObjects];
	[_chosenElementsImagesNames removeAllObjects];
	[_unchosenElementsImagesNames removeAllObjects];
	[_unchosenElementsImagesNames addObjectsFromArray:toolboxElementsImages];
		
	NSUInteger count = toolboxElementsImages.count;
	CGFloat width = floorf((self.toolboxCollectionView.frame.size.width - (count + 1) * FTINDraggableItemBoxViewToolSpacing) / count - 1.f);
	_toolSize = CGSizeMake(width, width);
	self.toolboxCollectionView.contentInset = UIEdgeInsetsMake((self.toolboxCollectionView.frame.size.height - width) / 2.f, FTINDraggableItemBoxViewToolSpacing, 0, FTINDraggableItemBoxViewToolSpacing);
	
	[self.toolboxCollectionView reloadData];
}

- (NSSet *)chosenElementsImagesNames
{
	return [NSSet setWithArray:_chosenElementsImagesNames.allValues];
}

- (void)reset
{
	for (UIView *view in _chosenElementsViews) {
		[self removeSelectedElement:view.gestureRecognizers[0]];
	}
}

- (void)removeSelectedElement:(UITapGestureRecognizer *)gestureRecognizer
{
	NSString *imageName = _chosenElementsImagesNames[@(gestureRecognizer.view.hash)];
	[_chosenElementsImagesNames removeObjectForKey:@(gestureRecognizer.view.hash)];
	[_unchosenElementsImagesNames addObject:imageName];
	
	[self.toolboxCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:(_unchosenElementsImagesNames.count - 1) inSection:0]]];
	
	[UIView animateWithDuration:FTINDefaultAnimationDuration animations:^{
		gestureRecognizer.view.layer.opacity = 0.f;
	} completion:^(BOOL finished) {
		[gestureRecognizer.view removeFromSuperview];
		[_chosenElementsViews removeObject:gestureRecognizer.view];
	}];
}

- (FTINCollectionViewCell *)copyCell:(FTINCollectionViewCell *)cell
{
	FTINCollectionViewCell *copy = [cell copy];
	copy.layer.cornerRadius = FTINDraggableItemBoxCellCornerRadius;
	copy.layer.masksToBounds = YES;
	copy.clipsToBounds = YES;
	return copy;
}

#pragma mark - Drag Source Delegate

- (UIView *)draggingViewForDragOperation:(DNDDragOperation *)operation
{
	UIView *copy = [self copyCell:(id)operation.dragSourceView];
	copy.layer.opacity = 0.f;
	
	[UIView animateWithDuration:FTINDefaultAnimationDuration animations:^{
		copy.layer.opacity = FTINDraggableItemBoxViewDragOpacity;
	}];
	
	return copy;
}

#pragma mark - Drag Target Delegate

- (void)dragOperation:(DNDDragOperation *)operation didDropInDropTarget:(UIView *)target
{
	CGRect copyFrame = operation.draggingView.frame;
	copyFrame.origin = [operation locationInView:target];
	copyFrame.origin.x -= copyFrame.size.width / 2.f;
	copyFrame.origin.y -= copyFrame.size.height / 2.f;
	
	UIView *copy = [self copyCell:(id)operation.draggingView];
	copy.frame = copyFrame;
	[target addSubview:copy];
	[target removeBorder];
	[copy setLocationInsideSuperview:YES];
	
	[copy addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelectedElement:)]];
	
	NSString *selectedImage = _unchosenElementsImagesNames[copy.tag];
	[_unchosenElementsImagesNames removeObjectAtIndex:copy.tag];
	[_chosenElementsImagesNames setObject:selectedImage forKey:@(copy.hash)];
	[_chosenElementsViews addObject:copy];
	[self.toolboxCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:copy.tag inSection:0]]];
	
	// Luiz: Gambibambi pois UICollectionView não atualiza as células.
	self.toolboxCollectionView.userInteractionEnabled = NO;
	[self.toolboxCollectionView performSelector:@selector(reloadData) withObject:nil afterDelay:.4];
}

- (void)dragOperationWillCancel:(DNDDragOperation *)operation
{
    [operation removeDraggingViewAnimatedWithDuration:0.2 animations:^(UIView *dv) {
		CGPoint location = operation.dragSourceView.center;
		location.y += operation.dragSourceView.frame.size.height / 2.f;
		
        dv.alpha = 0.0f;
        dv.center = location;
    }];
}

- (void)dragOperation:(DNDDragOperation *)operation didEnterDropTarget:(UIView *)target
{
	[target setBorder:FTINDraggableItemBoxSelectionBorderColor withWidth:FTINDraggableItemBoxSelectionBorderWidth];
}

- (void)dragOperation:(DNDDragOperation *)operation didLeaveDropTarget:(UIView *)target
{
	[target removeBorder];
}

#pragma mark - Collection View Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	self.toolboxCollectionView.userInteractionEnabled = YES;
	return self.toolboxElementsImagesNames.count - _chosenElementsImagesNames.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return _toolSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	FTINCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FTINCollectionViewCell cellIdentifier] forIndexPath:indexPath];
	cell.backgroundImageView.image = [UIImage imageNamed:_unchosenElementsImagesNames[indexPath.row]];
	cell.tag = indexPath.row;
	
	[_dragDropController registerDragSource:cell withDelegate:self];
	
	return cell;
}

@end
