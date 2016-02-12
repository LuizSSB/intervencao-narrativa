//
//  FTINQuestionCardsView.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINQuestionCardsView.h"
#import "FTINQuestionCardBackCollectionViewCell.h"
#import "FTINWhyGameQuestion.h"

CGSize const FTINQuestionCardsViewCellSize = {200.f, 275.f};
CGFloat const FTINQuestionCardsViewCellSpacing = 35.f;
CGFloat const FTINQuestionCardsViewOverlayOpacity = .65f;

@interface FTINQuestionCardsView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
	CGRect _activeCellFrame;
	NSUInteger _activeCellTag;
}

@property (nonatomic, readonly) UIImageView *pulledCardImageView;

- (void)setup;

@end

@implementation FTINQuestionCardsView

#pragma mark - Super methods

- (void)dealloc
{
	_pulledCardImageView = nil;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
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
	fitSize.width = self.questions.count * FTINQuestionCardsViewCellSize.width + FTINQuestionCardsViewCellSpacing * (self.questions.count - 1) + self.contentInset.left + self.contentInset.right + 1.f; //Esse último 1 é pra não quebrar. Confie em mim.
	double totalTimes = ceil(fitSize.width / size.width);
	
	fitSize.height = self.contentInset.top + self.contentInset.bottom + totalTimes * FTINQuestionCardsViewCellSize.height + (totalTimes - 1) * FTINQuestionCardsViewCellSpacing;
	
	while (fitSize.width > size.width && fitSize.width > 0) {
		CGFloat space = (FTINQuestionCardsViewCellSize.width + FTINQuestionCardsViewCellSpacing);
		fitSize.width -= space;
	}
	
	return CGSizeMake(MIN(size.width, fitSize.width), MIN(size.height, fitSize.height));
}

#pragma mark - Instance methods

- (void)setup
{
	self.scrollEnabled = NO;
	self.delegate = self;
	self.dataSource = self;
	
	[self registerClass:[FTINQuestionCardBackCollectionViewCell class] forCellWithReuseIdentifier:FTINDefaultCellIdentifier];
}

- (void)setQuestions:(NSArray *)questions
{
	_questions = questions;
	[self reloadData];
}

@synthesize pulledCardImageView = _pulledCardImageView;
- (UIImageView *)pulledCardImageView
{
	if(!_pulledCardImageView)
	{
		_pulledCardImageView = [[UIImageView alloc] initWithImage:[UIImage lssb_imageNamed:@"cardback"]];
		_pulledCardImageView.frame = CGRectMake(0, 0, FTINQuestionCardsViewCellSize.width, FTINQuestionCardsViewCellSize.height);
		_pulledCardImageView.hidden = YES;
		_pulledCardImageView.layer.zPosition = MAXFLOAT;
		[self addSubview:_pulledCardImageView];
	}
	
	return _pulledCardImageView;
}

// TODO support multi card selection
- (void)unselectQuestion:(FTINWhyGameQuestion *)question
{
	[UIView animateWithDuration:FTINDefaultAnimationDuration animations:^{
		self.pulledCardImageView.frame = _activeCellFrame;
	} completion:^(BOOL finished) {
		self.pulledCardImageView.hidden = YES;
		[self reloadData];
		[self viewWithTag:_activeCellTag].hidden = NO;
		self.userInteractionEnabled = YES;
	}];
}

#pragma mark - Collection View Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.questions.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return FTINQuestionCardsViewCellSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
	return FTINQuestionCardsViewCellSpacing;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	FTINQuestionCardBackCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FTINDefaultCellIdentifier forIndexPath:indexPath];
	cell.tag = cell.hash;
	cell.answered = [self.questions[indexPath.row] answered];
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	FTINCollectionViewCell *cell = (id) [collectionView cellForItemAtIndexPath:indexPath];
	cell.hidden = YES;
	
	_activeCellTag = cell.tag;
	_activeCellFrame = cell.frame;
	
	self.pulledCardImageView.frame = cell.frame;
	self.pulledCardImageView.hidden = NO;
	
	self.userInteractionEnabled = NO;
	
	[UIView animateWithDuration:FTINDefaultAnimationDuration animations:^{
		CGRect pulledCardFrame = self.pulledCardImageView.frame;
		pulledCardFrame.origin.x = (self.frame.size.width - pulledCardFrame.size.width) / 2.f;
		pulledCardFrame.origin.y = CGRectGetMaxY(self.frame);
		
		self.pulledCardImageView.frame = pulledCardFrame;
	} completion:^(BOOL finished) {
		[self.questionsDelegate questionCardsView:self selectedQuestion:self.questions[indexPath.row]];
	}];
}

@end
