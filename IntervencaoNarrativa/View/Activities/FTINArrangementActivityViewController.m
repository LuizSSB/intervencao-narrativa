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
	FTINArrangementSubActivityContent *_content;
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
	_content = nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.itemsArrangementView.items = _content.elementsImages;
	
	[self.itemsArrangementView sizeToFit];
	self.itemsArrangementView.center = self.view.center;
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
	UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	fixedSpace.width = FTINBarButtonItemSpacing;
	
	return @[
			 self.arrangementBarButton,
			 fixedSpace,
			 self.narrativeSkillBarButton,
			 [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]
			 ];
}

- (BOOL)prepareToGoToNextActivity
{
	[self.narrationViewController dismissPopoverAnimated:YES];
	[self.arrangementViewController dismissPopoverAnimated:YES];
	
	ArrangementSubActivity *tr00Activity = (ArrangementSubActivity *)self.subActivity.data;
	
	if(self.narrationViewController.hasSelectedChoice)
	{
		tr00Activity.narrativeSkill = self.narrationViewController.selectedSkill;
	}
	
	if(self.arrangementViewController.hasSelectedChoice)
	{
		tr00Activity.arrangementSkill = self.arrangementViewController.selectedSkill;
	}
	
	tr00Activity.itemsArrangement = self.itemsArrangementView.items;
	
	return YES;
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

@end
