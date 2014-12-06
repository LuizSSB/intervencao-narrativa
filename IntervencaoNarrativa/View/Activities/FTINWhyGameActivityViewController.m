//
//  FTINWhyGameActivityViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINWhyGameActivityViewController.h"
#import "FTINQuestionsChoiceViewController.h"
#import "FTINQuestionCardsView.h"
#import "FTINQuestionCardViewController.h"

#import "FTINSubActivityDetails.h"
#import "FTINWhyGameSubActivityContent.h"

#import "WhyGameSubActivity+Complete.h"

@interface FTINWhyGameActivityViewController () <FTINQuestionsChoiceViewControllerDelegate, FTINQuestionCardsViewDelegate, FTINQuestionCardViewControllerDelegate, UIAlertViewDelegate>
{
	WhyGameSubActivity *_subActivityData;
	NSArray *_questions;
}

@property (weak, nonatomic) IBOutlet FTINQuestionCardsView *questionCardsView;
@property (strong, nonatomic) IBOutlet FTINQuestionsChoiceViewController *questionsChoiceViewController;

- (void)reset:(id)sender;
- (void)showCardsOfFate:(BOOL)animated;

@end

@implementation FTINWhyGameActivityViewController

#pragma mark - Super methods

- (void)dealloc
{
	_subActivityData = nil;
	_questionsChoiceViewController = nil;
	_questions = nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	_questions = ((FTINWhyGameSubActivityContent *) self.subActivity.content).questions;
	_subActivityData = (id) self.subActivity.data;
	
	if (!_subActivityData.questions) {
		_subActivityData.questions = [NSSet setWithArray:_questions];
	}
	
	NSSet *chosenQuestions = _subActivityData.chosenQuestions;
	if(chosenQuestions.count)
	{
		self.questionCardsView.questions = chosenQuestions.allObjects;
		[self showCardsOfFate:NO];
	}
	
	self.questionCardsView.questionsDelegate = self;
	
	self.questionsChoiceViewController.choices = _questions;
	self.questionsChoiceViewController.questionsDelegate = self;
}

- (NSArray *)getNavigationItemRightBarButtons
{
	return @[[[UIBarButtonItem alloc] initWithTitle:@"restart".localizedString style:UIBarButtonItemStyleBordered target:self action:@selector(reset:)]];
}

#pragma mark - Instance methods

- (void)reset:(id)sender
{
	[[UIAlertView alertWithConfirmation:@"confirm_reset".localizedString delegate:self] show];
}

- (void)showCardsOfFate:(BOOL)animated
{
	self.questionCardsView.hidden = NO;
	
	void (^setOpacity)() = ^void() {
		self.questionCardsView.layer.opacity = 1.f;
		self.questionsChoiceViewController.view.layer.opacity = 0.f;
	};
	
	if(animated)
	{
		[UIView animateWithDuration:FTINDefaultAnimationDuration animations:^{
			setOpacity();
		} completion:nil];
	}
	else
	{
		setOpacity();
	}
}

#pragma mark - Questions Choice View Controller Delegate

- (void)questionsChoiceViewController:(FTINQuestionsChoiceViewController *)viewController choseQuestions:(NSArray *)questions
{
	[questions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[obj setChosen:YES];
	}];
	
	self.questionCardsView.questions = questions;
	[self showCardsOfFate:YES];
}

#pragma mark - Question Cards View Delegate

- (void)questionCardsView:(FTINQuestionCardsView *)questionCardsView selectedQuestion:(FTINWhyGameQuestion *)question
{
	FTINQuestionCardViewController *cardViewController = [[FTINQuestionCardViewController alloc] initWithQuestion:question andDelegate:self];
	cardViewController.showsAnswerVisiblityControl = !self.editing;
	[self presentViewController:cardViewController animated:YES completion:nil];
}

#pragma mark - Question Card View Controller Delegate

- (void)questionCardViewController:(FTINQuestionCardViewController *)viewController finishedWithAnswerSkill:(FTINAnswerSkill)skill
{
	viewController.question.answerSkill = skill;
	[self questionCardViewControllerCanceled:viewController];
}

- (void)questionCardViewControllerCanceled:(FTINQuestionCardViewController *)viewController
{
	[self dismissViewControllerAnimated:YES completion:^{
		[self.questionCardsView unselectQuestion:viewController.question];
	}];
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex != alertView.cancelButtonIndex)
	{
		[_questions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[obj setChosen:NO];
		}];
		
		[UIView animateWithDuration:FTINDefaultAnimationDuration animations:^{
			self.questionCardsView.layer.opacity = 0.f;
			self.questionsChoiceViewController.view.layer.opacity = 1.f;
		} completion:nil];
	}
}

@end
