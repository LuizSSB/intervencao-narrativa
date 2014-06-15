//
//  FTINWhyGameActivityViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINWhyGameActivityViewController.h"
#import "FTINAnswerSkillChoiceViewController.h"

#import "FTINSubActivityDetails.h"
#import "FTINWhyGameSubActivityContent.h"
#import "WhyGameSubActivity+Complete.h"

@interface FTINWhyGameActivityViewController ()
{
	FTINWhyGameSubActivityContent *_content;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *answerSkillBarButton;
- (IBAction)showAnswerSkill:(id)sender;

@property (nonatomic, readonly) FTINAnswerSkillChoiceViewController *answerViewController;

@end

@implementation FTINWhyGameActivityViewController

#pragma mark - Super methods

- (void)dealloc
{
	_content = nil;
	self.answerSkillBarButton = nil;
	_answerViewController = nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (instancetype)initWithSubActivity:(FTINSubActivityDetails *)subactivity andDelegate:(id<FTINActivityViewControllerDelegate>)delegate
{
    self = [super initWithSubActivity:subactivity andDelegate:delegate];
    if (self) {
        _content = (id) subactivity.content;
    }
    return self;
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
		[(WhyGameSubActivity *)self.subActivity.data setAnswerSkill:self.answerViewController.selectedSkill];
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
