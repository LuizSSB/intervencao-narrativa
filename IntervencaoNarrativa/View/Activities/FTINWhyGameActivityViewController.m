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

@interface FTINWhyGameActivityViewController () <FTINQuestionsChoiceViewControllerDelegate>
{
	WhyGameSubActivity *_subActivityData;
}

@property (weak, nonatomic) IBOutlet FTINQuestionCardsView *questionCardsView;
@property (strong, nonatomic) IBOutlet FTINQuestionsChoiceViewController *questionsChoiceViewController;

- (void)deallocChoiceViewController;

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
	
	NSArray *questions = ((FTINWhyGameSubActivityContent *) self.subActivity.content).questions;
	self.questionsChoiceViewController.choices = questions;
	self.questionsChoiceViewController.questionsDelegate = self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:YES];
	self.questionCardsView.showsAnswers = !editing;
}

- (BOOL)prepareToGoToNextActivity
{
	[_subActivityData unchooseAllQuestions];
	
	for (FTINWhyGameQuestion *question in self.questionCardsView.questions)
	{
		[_subActivityData chooseQuestionWithContent:question];
		
		if([self.questionCardsView hasAnswerSkillForQuestion:question])
		{
			[_subActivityData setSkill:[self.questionCardsView answerSkillForQuestion:question] forQuestionWithContent:question];
		}
	}
	
	return YES;
}

#pragma mark - Instance methods

- (void)deallocChoiceViewController
{
	[self.questionsChoiceViewController.view removeFromSuperview];
	self.questionsChoiceViewController = nil;
}

#pragma mark - Questions Choice View Controller Delegate

- (void)questionsChoiceViewController:(FTINQuestionsChoiceViewController *)viewController choseQuestions:(NSArray *)questions
{
	self.questionCardsView.hidden = NO;
	self.questionCardsView.questions = questions;
	
	[UIView animateWithDuration:FTINDefaultAnimationDuration animations:^{
		self.questionCardsView.layer.opacity = 1.f;
		self.questionsChoiceViewController.view.layer.opacity = 0.f;
	} completion:^(BOOL finished) {
		[self deallocChoiceViewController];
	}];
}

@end
