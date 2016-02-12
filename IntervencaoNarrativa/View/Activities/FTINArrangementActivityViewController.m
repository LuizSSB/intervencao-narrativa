//
//  FTINOrderingActivityViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/10.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINArrangementActivityViewController.h"
#import "FTINArrangementSkillChoiceViewController.h"
#import "FTINNarrativeSkillChoiceViewController.h"

#import "FTINSubActivityDetails.h"
#import "FTINArrangementSubActivityContent.h"
#import "ArrangementSubActivity+Complete.h"

#import "FTINImageArrangementView.h"

@interface FTINArrangementActivityViewController ()
{
	ArrangementSubActivity *_subActivityData;
}

@property (weak, nonatomic) IBOutlet FTINImageArrangementView *itemsArrangementView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *arrangementBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *narrativeSkillBarButton;

- (IBAction)showArrangement:(UIBarButtonItem *)sender;
- (IBAction)showNarrativeSkill:(UIBarButtonItem *)sender;

@property (nonatomic, readonly) FTINArrangementSkillChoiceViewController *arrangementViewController;
@property (nonatomic, readonly) FTINNarrativeSkillChoiceViewController *narrationViewController;

@end

@implementation FTINArrangementActivityViewController

#pragma mark - Super methods

- (void)dealloc
{
	self.arrangementBarButton = nil;
	self.narrativeSkillBarButton = nil;
	_arrangementViewController = nil;
	_narrationViewController = nil;
	_subActivityData = nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	_subActivityData = (ArrangementSubActivity *)self.subActivity.data;

	if(_subActivityData.finished)
	{
		[self.itemsArrangementView setItems:_subActivityData.itemsArrangement shuffling:NO];
		self.arrangementViewController.selectedSkill = _subActivityData.arrangementSkill;
		self.narrationViewController.selectedSkill = _subActivityData.narrativeSkill;
		self.itemsArrangementView.userInteractionEnabled = NO;
		
		if(_subActivityData.failed)
		{
			[self hideSkillButtons];
		}
	}
	else
	{
		self.itemsArrangementView.items = ((FTINArrangementSubActivityContent *) self.subActivity.content).elements;
	}
		
	[self.itemsArrangementView sizeToFit];
	self.itemsArrangementView.center = self.view.center;
}

- (NSArray *)getActionBarButtons
{
	UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	fixedSpace.width = FTINBarButtonItemSpacing;
	
	return @[
			 self.arrangementBarButton,
			 fixedSpace,
			 self.narrativeSkillBarButton
			 ];
}

- (BOOL)prepareToGoToNextActivity
{
	[self.narrationViewController dismissPopoverAnimated:YES];
	[self.arrangementViewController dismissPopoverAnimated:YES];
	
	
	if(self.narrationViewController.hasSelectedChoice)
	{
		_subActivityData.narrativeSkill = self.narrationViewController.selectedSkill;
	}
	
	if(self.arrangementViewController.hasSelectedChoice)
	{
		_subActivityData.arrangementSkill = self.arrangementViewController.selectedSkill;
	}
	
	_subActivityData.itemsArrangement = self.itemsArrangementView.items;
	
	return YES;
}

- (void)showAnswer
{
	[super showAnswer];
	
	self.itemsArrangementView.userInteractionEnabled = NO;
	
	[UIView animateWithDuration:FTINDefaultAnimationShortDuration animations:^{
		self.itemsArrangementView.layer.opacity = 0.;
		
	} completion:^(BOOL finished) {
		[self.itemsArrangementView setItems:((FTINArrangementSubActivityContent *) self.subActivity.content).elements shuffling:NO];
		
		[UIView animateWithDuration:FTINDefaultAnimationShortDuration animations:^{
			self.itemsArrangementView.layer.opacity = 1.;
		}];
	}];
	
	[self hideSkillButtons];
}

#pragma mark - Instance methods

- (IBAction)showArrangement:(UIBarButtonItem *)sender
{
	[self.narrationViewController dismissPopoverAnimated:YES];
	[self.arrangementViewController presentAsPopoverFromBarButtonItem:sender animated:YES];
}

- (IBAction)showNarrativeSkill:(UIBarButtonItem *)sender
{
	[self.arrangementViewController dismissPopoverAnimated:YES];
	[self.narrationViewController presentAsPopoverFromBarButtonItem:sender animated:YES];
}

@synthesize arrangementViewController = _arrangementViewController;

- (FTINArrangementSkillChoiceViewController *)arrangementViewController
{
	if(!_arrangementViewController)
	{
		_arrangementViewController = [[FTINArrangementSkillChoiceViewController alloc] init];
		_arrangementViewController.title = self.arrangementBarButton.title;
	}
	
	return _arrangementViewController;
}

@synthesize  narrationViewController = _narrationViewController;

- (FTINNarrativeSkillChoiceViewController *)narrationViewController
{
	if(!_narrationViewController)
	{
		_narrationViewController = [[FTINNarrativeSkillChoiceViewController alloc] init];
		_narrationViewController.title = self.narrativeSkillBarButton.title;
	}
	
	return _narrationViewController;
}

- (void)hideSkillButtons
{
	self.arrangementBarButton.title = self.narrativeSkillBarButton.title = [NSString string];
	self.arrangementBarButton.enabled = self.narrativeSkillBarButton.enabled = NO;
}

@end
