//
//  FTINImageArrangementView.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/11.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINImageArrangementView.h"
#import "FTINCollectionViewCell.h"

CGSize const FTINImageArrangementViewCellSize = {200.f, 200.f};
CGFloat const FTINImageArrangementViewCellSpacing = 35.f;
NSTimeInterval const FTINImageArrangementViewMinimumPressDuration = .03;

@interface FTINImageArrangementView () <UICollectionViewDelegate, LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout>
{
	NSMutableArray *_items;
}

- (void)setup;

@end

@implementation FTINImageArrangementView

#pragma mark - Super methods

- (void)dealloc
{
	_items = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)sizeToFit
{
	CGRect frame = self.frame;
	frame.size = [self sizeThatFits:(self.superview ? self.superview.frame.size : CGSizeMake(INFINITY, INFINITY))];
	self.frame = frame;
}

// Luiz: implementação tá horrorosa, mas ok, to sem cabeça pra isso agora.
- (CGSize)sizeThatFits:(CGSize)size
{
	CGSize fitSize;
	fitSize.width = self.items.count * FTINImageArrangementViewCellSize.width + FTINImageArrangementViewCellSpacing * (self.items.count - 1) + self.contentInset.left + self.contentInset.right + 1.f; //Esse último 1 é pra não quebrar. Confie em mim.
	double totalTimes = ceil(fitSize.width / size.width);
	
	fitSize.height = self.contentInset.top + self.contentInset.bottom + totalTimes * FTINImageArrangementViewCellSize.height + (totalTimes - 1) * FTINImageArrangementViewCellSpacing;
	
	while (fitSize.width > size.width && fitSize.width > 0) {
		CGFloat space = (FTINImageArrangementViewCellSize.width + FTINImageArrangementViewCellSpacing);
		fitSize.width -= space;
	}
	
	if(!CGSizeEqualToSize(size, CGSizeMake(INFINITY, INFINITY))) {
		CGFloat rows = floorf(fitSize.height / FTINImageArrangementViewCellSize.height);
		CGFloat columns = floorf(fitSize.width / FTINImageArrangementViewCellSize.width);
		
		while (rows * columns > self.items.count + 1) {
			CGFloat space = (FTINImageArrangementViewCellSize.width + FTINImageArrangementViewCellSpacing);
			fitSize.width -= space;
			--columns;
		}
	}
	

	return CGSizeMake(MIN(size.width, fitSize.width), MIN(size.height, fitSize.height));
}

#pragma mark - Instance methods

- (void)setup
{
	[self registerNib:[UINib nibWithNibName:NSStringFromClass([FTINCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[FTINCollectionViewCell cellIdentifier]];
	[self registerClass:[FTINCollectionViewCell class] forCellWithReuseIdentifier:[FTINCollectionViewCell cellIdentifier]];
	self.delegate = self;
	self.dataSource = self;

	if(![self.collectionViewLayout isKindOfClass:[LXReorderableCollectionViewFlowLayout class]])
	{
		LXReorderableCollectionViewFlowLayout *layout = [[LXReorderableCollectionViewFlowLayout alloc] init];
		self.collectionViewLayout = layout;
	}
	
	LXReorderableCollectionViewFlowLayout *layout = (LXReorderableCollectionViewFlowLayout *)self.collectionViewLayout;
	layout.longPressGestureRecognizer.minimumPressDuration = FTINImageArrangementViewMinimumPressDuration;
	layout.minimumInteritemSpacing = FTINImageArrangementViewCellSpacing;
	
	[self sizeToFit];
	self.clipsToBounds = NO;
}

@synthesize items = _items;

- (void)setItems:(NSArray *)items
{
	[self setItems:items shuffling:YES];
}

- (void)setItems:(NSArray *)items shuffling:(BOOL)shuffles
{
	NSArray *shuffled;
	
	if(shuffles)
	{
		do
		{
			shuffled = [items shuffledArray];
		}
		while ([shuffled isEqual:items]);
	}
	else
	{
		shuffled = items;
	}
	
	_items = [NSMutableArray arrayWithArray:shuffled];
	[self reloadData];
}

#pragma mark - Collection View Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	FTINCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FTINCollectionViewCell cellIdentifier] forIndexPath:indexPath];
	
	NSString *imageName = self.items[indexPath.row];
	cell.backgroundImageView.image = [UIImage lssb_imageNamed:imageName];
	cell.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
	
	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return FTINImageArrangementViewCellSize;
}

#pragma mark - Reorderable Collection View Delegate Flow Layout

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
	id item = self.items[fromIndexPath.row];
	[_items removeObjectAtIndex:fromIndexPath.row];
	[_items insertObject:item atIndex:toIndexPath.row];
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
	collectionView.userInteractionEnabled = NO;
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
	//FIX duns bug do UICollectionView
	for (UIView *view in self.subviews)
	{
		if(![view isKindOfClass:[UICollectionViewCell class]])
		{
			[view removeFromSuperview];
		}
	}
	[self reloadData];
	collectionView.userInteractionEnabled = YES;
}

@end
