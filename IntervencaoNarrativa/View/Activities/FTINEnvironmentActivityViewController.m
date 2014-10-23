//
//  FTINEnvironmentActivityViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINEnvironmentActivityViewController.h"
#import "FTINCoherenceChoiceViewController.h"

#import "FTINDraggableItemBoxView.h"

#import "FTINSubActivityDetails.h"
#import "FTINEnvironmentSubActivityContent.h"
#import "EnvironmentSubActivity+Complete.h"

@interface FTINEnvironmentActivityViewController ()
{
	EnvironmentSubActivity *_subActivityData;
}

@property (weak, nonatomic) IBOutlet FTINDraggableItemBoxView *draggableElementBox;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *organizationBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *narrationBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *resetBarButton;

- (IBAction)showOrganizationChoices:(UIBarButtonItem *)sender;
- (IBAction)showNarrationChoices:(UIBarButtonItem *)sender;
- (IBAction)reset:(id)sender;

@property (nonatomic, strong) FTINCoherenceChoiceViewController *organizationViewController;
@property (nonatomic, strong) FTINCoherenceChoiceViewController *narrationViewController;

@end

@implementation FTINEnvironmentActivityViewController

#pragma mark - Super methods

- (void)dealloc
{
	_organizationViewController = nil;
	_narrationViewController = nil;
	_organizationBarButton = nil;
	_narrationBarButton = nil;
	_resetBarButton = nil;
	_subActivityData = nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	FTINEnvironmentSubActivityContent *_content = (FTINEnvironmentSubActivityContent *) self.subActivity.content;
	self.draggableElementBox.toolboxElements = _content.allElements;
	self.draggableElementBox.backgroundImageView.image = [UIImage imageNamed:_content.background];

	if (_subActivityData.completed)
	{
		self.draggableElementBox.chosenElements = _subActivityData.selectedElements;
		self.draggableElementBox.userInteractionEnabled = NO;
		self.narrationViewController.selectedCoherence = _subActivityData.narrationCoherence;
		self.organizationViewController.selectedCoherence = _subActivityData.organizationCoherence;
	}
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	
	NSArray *rightButtons = editing ? @[self.editButtonItem] : @[self.editButtonItem, self.resetBarButton];	
	
	[self.navigationItem setRightBarButtonItems:rightButtons animated:YES];
}

- (instancetype)initWithSubActivity:(FTINSubActivityDetails *)subactivity andDelegate:(id<FTINActivityViewControllerDelegate>)delegate
{
    self = [super initWithSubActivity:subactivity andDelegate:delegate];
    if (self) {
		_subActivityData = (id) self.subActivity.data;
    }
    return self;
}

- (NSArray *)getNavigationItemRightBarButtons
{
	return _subActivityData.completed ? nil : @[self.resetBarButton];
}

- (NSArray *)getActionBarButtons
{
	UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	fixedSpace.width = FTINBarButtonItemSpacing;
	
	return @[
			 self.organizationBarButton,
			 fixedSpace,
			 self.narrationBarButton
			 ];
}

- (BOOL)prepareToGoToNextActivity
{
	[self.narrationViewController dismissPopoverAnimated:NO];
	[self.organizationViewController dismissPopoverAnimated:NO];
	
	if(self.organizationViewController.hasSelectedChoice)
	{
		_subActivityData.organizationCoherence = self.organizationViewController.selectedCoherence;
	}
	
	if(self.narrationViewController.hasSelectedChoice)
	{
		_subActivityData.narrationCoherence = self.narrationViewController.selectedCoherence;
	}
	
	_subActivityData.selectedElements = self.draggableElementBox.chosenElements;
	_subActivityData.unselectedElements = [(FTINEnvironmentSubActivityContent *) self.subActivity.content filterCorrectElements:self.draggableElementBox.unchosenElements];
	
	return YES;
}

#pragma mark - Instance methods

- (IBAction)showOrganizationChoices:(UIBarButtonItem *)sender {
	[self.narrationViewController dismissPopoverAnimated:YES];
	[self.organizationViewController presentAsPopoverFromBarButtonItem:sender animated:YES];
}

- (IBAction)showNarrationChoices:(UIBarButtonItem *)sender {
	[self.organizationViewController dismissPopoverAnimated:YES];
	[self.narrationViewController presentAsPopoverFromBarButtonItem:sender animated:YES];
}

- (IBAction)reset:(id)sender
{
	[self.draggableElementBox reset:YES];
}

@synthesize organizationViewController = _organizationViewController;

- (FTINCoherenceChoiceViewController *)organizationViewController
{
	if(!_organizationViewController)
	{
		_organizationViewController = [[FTINCoherenceChoiceViewController alloc] initWithChoiceTextPrefix:@"coherence_organization".localizedString];
	}
	
	return _organizationViewController;
}

@synthesize narrationViewController = _narrationViewController;

- (FTINCoherenceChoiceViewController *)narrationViewController
{
	if(!_narrationViewController)
	{
		_narrationViewController = [[FTINCoherenceChoiceViewController alloc] initWithChoiceTextPrefix:@"coherence_narration".localizedString];
	}
	
	return _narrationViewController;
}

@end
