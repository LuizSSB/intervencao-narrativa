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

#import "FTINSubActivityDetails.h"
#import "FTINWhyGameSubActivityContent.h"
#import "WhyGameSubActivity+Complete.h"

@interface FTINWhyGameActivityViewController () <FTINQuestionsChoiceViewControllerDelegate, FTINQuestionCardsViewDelegate, UIAlertViewDelegate>
{
	WhyGameSubActivity *_subActivityData;
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
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	_subActivityData = (id) self.subActivity.data;
	
	NSDictionary *chosenQuestions = [_subActivityData getChosenQuestionsContentsWithSkills];
	if(chosenQuestions.count)
	{
		[self.questionCardsView setQuestionsWithAnswerSkills:chosenQuestions];
		[self showCardsOfFate:NO];
	}
	
	self.questionCardsView.questionsDelegate = self;
	self.questionCardsView.parentViewController = self;
	
	NSArray *questions = ((FTINWhyGameSubActivityContent *) self.subActivity.content).questions;
	self.questionsChoiceViewController.choices = questions;
	self.questionsChoiceViewController.questionsDelegate = self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:YES];
	self.questionCardsView.showsAnswers = !editing;
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
	self.questionCardsView.questions = questions;
	[_subActivityData chooseQuestionsWithContents:questions];
	
	[self showCardsOfFate:YES];
}

#pragma mark - Question Cards View Delegate

- (void)questionCardsView:(FTINQuestionCardsView *)questionCardsView selectedAnswerSkill:(FTINAnswerSkill)answerSkill forQuestion:(FTINWhyGameQuestion *)question
{
	[_subActivityData setSkill:answerSkill forQuestionWithContent:question];
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex != alertView.cancelButtonIndex)
	{
		[_subActivityData unchooseAllQuestions];
		
		[UIView animateWithDuration:FTINDefaultAnimationDuration animations:^{
			self.questionCardsView.layer.opacity = 0.f;
			self.questionsChoiceViewController.view.layer.opacity = 1.f;
		} completion:nil];
	}
}

@end
