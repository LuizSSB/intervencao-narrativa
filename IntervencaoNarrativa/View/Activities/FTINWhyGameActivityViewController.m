//
//  FTINWhyGameActivityViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINWhyGameActivityViewController.h"
#import "FTINAnswerSkillChoiceViewController.h"
#import "FTINQuestionCardsView.h"

#import "FTINSubActivityDetails.h"
#import "FTINWhyGameSubActivityContent.h"
#import "WhyGameSubActivity+Complete.h"

@interface FTINWhyGameActivityViewController ()
{
	WhyGameSubActivity *_subActivityData;
}

@property (weak, nonatomic) IBOutlet FTINQuestionCardsView *questionCardsView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *answerSkillBarButton;
- (IBAction)showAnswerSkill:(id)sender;

@property (nonatomic, readonly) FTINAnswerSkillChoiceViewController *answerViewController;

@end

@implementation FTINWhyGameActivityViewController

#pragma mark - Super methods

- (void)dealloc
{
	self.answerSkillBarButton = nil;
	_answerViewController = nil;
	_subActivityData = nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.questionCardsView.questions = ((FTINWhyGameSubActivityContent *) self.subActivity.content).questions;
	self.questionCardsView.center = self.view.center;
	
	_subActivityData = (id) self.subActivity.data;
	
	if(_subActivityData.completed)
	{
		self.answerViewController.selectedSkill = _subActivityData.answerSkill;
	}
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:YES];
	self.questionCardsView.showsAnswers = editing;
}

- (NSArray *)getActionBarButtons
{
	return @[self.answerSkillBarButton];
}

- (BOOL)prepareToGoToNextActivity
{
	[self.answerViewController dismissPopoverAnimated:YES];
	
	if(self.answerViewController.hasSelectedChoice)
	{
		[_subActivityData setAnswerSkill:self.answerViewController.selectedSkill];
	}
	
	return YES;
}

#pragma mark - Instance methods

- (void)showAnswerSkill:(id)sender
{
	[self.answerViewController presentAsPopoverFromBarButtonItem:sender animated:YES];
}

@synthesize answerViewController = _answerViewController;
- (FTINAnswerSkillChoiceViewController *)answerViewController
{
	if(!_answerViewController)
	{
		_answerViewController = [[FTINAnswerSkillChoiceViewController alloc] init];
		_answerViewController.title = self.answerSkillBarButton.title;
		_answerViewController.popoverWidth = 400.f;
	}
	
	return _answerViewController;
}

@end
