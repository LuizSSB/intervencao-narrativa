//
//  FTINQuestionCardsView.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINQuestionCardsView.h"
#import "FTINCollectionViewCell.h"
#import "FTINQuestionCardViewController.h"

CGSize const FTINQuestionCardsViewCellSize = {200.f, 300.f};
CGFloat const FTINQuestionCardsViewCellSpacing = 35.f;
CGFloat const FTINQuestionCardsViewOverlayOpacity = .65f;

@interface FTINQuestionCardsView () <FTINQuestionCardViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
	CGRect _activeCellFrame;
	NSUInteger _activeCellTag;
}

@property (nonatomic, readonly) UIButton *closeQuestionOverlayButton;
@property (nonatomic, readonly) UIImageView *pulledCardImageView;
@property (nonatomic, readonly) FTINQuestionCardViewController *questionViewController;

- (void)setup;

@end

@implementation FTINQuestionCardsView

#pragma mark - Super methods

- (void)dealloc
{
	_questions = nil;
	_pulledCardImageView = nil;
	_questionViewController = nil;
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
	
	[self registerClass:[FTINCollectionViewCell class] forCellWithReuseIdentifier:FTINDefaultCellIdentifier.description];
}

- (BOOL)showsAnswers
{
	return self.questionViewController.showsAnswerVisiblityControl;
}

- (void)setShowsAnswers:(BOOL)showsAnswers
{
	self.questionViewController.showsAnswerVisiblityControl = showsAnswers;
}

- (void)setQuestions:(NSArray *)questions
{
	_questions = [questions shuffledArray];
	[self reloadData];
}

@synthesize closeQuestionOverlayButton = _closeQuestionOverlayButton;

- (UIButton *)closeQuestionOverlayButton
{
	if(!_closeQuestionOverlayButton)
	{
		_closeQuestionOverlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_closeQuestionOverlayButton addTarget:self action:@selector(questionCardViewControllerFinished:) forControlEvents:UIControlEventTouchUpInside];
		_closeQuestionOverlayButton.backgroundColor = [UIColor blackColor];
		_closeQuestionOverlayButton.layer.opacity = 0.f;
	}
	
	_closeQuestionOverlayButton.frame = self.superview.bounds;
	return _closeQuestionOverlayButton;
}

@synthesize questionViewController = _questionViewController;

- (FTINQuestionCardViewController *)questionViewController
{
	if(!_questionViewController)
	{
		_questionViewController = [[FTINQuestionCardViewController alloc] initWithDelegate:self];
		
		CGRect viewFrame = _questionViewController.view.frame;
		viewFrame.origin.x = self.superview.center.x - viewFrame.size.width / 2.f;
		viewFrame.origin.y = self.superview.frame.size.height;
		_questionViewController.view.frame = viewFrame;
	}
	
	return _questionViewController;
}

@synthesize pulledCardImageView = _pulledCardImageView;

- (UIImageView *)pulledCardImageView
{
	if(!_pulledCardImageView)
	{
		_pulledCardImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cardback.jpg"]];
		_pulledCardImageView.frame = CGRectMake(0, 0, FTINQuestionCardsViewCellSize.width, FTINQuestionCardsViewCellSize.height);
		_pulledCardImageView.hidden = YES;
		_pulledCardImageView.layer.zPosition = MAXFLOAT;
		[self addSubview:_pulledCardImageView];
	}
	
	return _pulledCardImageView;
}

#pragma mark - Question Card View Controller Delegate

- (void)questionCardViewControllerFinished:(FTINQuestionCardViewController *)viewController
{
	[UIView animateWithDuration:FTINDefaultAnimationDuration animations:^{
		CGRect viewFrame = _questionViewController.view.frame;
		viewFrame.origin.y = self.superview.frame.size.height;
		self.questionViewController.view.frame = viewFrame;
		
		self.closeQuestionOverlayButton.layer.opacity = 0;
	} completion:^(BOOL finished) {
		[self.questionViewController.view removeFromSuperview];
		[self.closeQuestionOverlayButton removeFromSuperview];
		
		[UIView animateWithDuration:FTINDefaultAnimationDuration animations:^{
			self.pulledCardImageView.frame = _activeCellFrame;
		} completion:^(BOOL finished) {
			self.pulledCardImageView.hidden = YES;
			[self viewWithTag:_activeCellTag].hidden = NO;
			self.userInteractionEnabled = YES;
		}];
	}];
}

- (BOOL)questionCardViewControllerShowsAnswer:(FTINQuestionCardViewController *)viewController
{
	return self.showsAnswers;
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
	FTINCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FTINDefaultCellIdentifier.description forIndexPath:indexPath];
	cell.backgroundImageView.image = [UIImage imageNamed:@"cardback.jpg"];
	cell.tag = cell.hash;
	
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
		self.questionViewController.question = self.questions[indexPath.row];
		[self.superview addSubview:self.closeQuestionOverlayButton];
		[self.superview addSubview:self.questionViewController.view];
		[UIView animateWithDuration:FTINDefaultAnimationDuration animations:^{
			self.closeQuestionOverlayButton.layer.opacity = FTINQuestionCardsViewOverlayOpacity;
			
			CGRect questionFrame = self.questionViewController.view.frame;
			questionFrame.origin.y = (self.frame.size.height - questionFrame.size.height) / 2.f;
			self.questionViewController.view.frame = questionFrame;
		}];
	}];
}

@end
