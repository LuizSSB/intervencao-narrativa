//
//  FTINEnvironmentActivityViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINEnvironmentActivityViewController.h"
#import "FTINCoherenceChoiceViewController.h"
#import "FTINSubActivityDetails.h"
#import "FTINEnvironmentSubActivityContent.h"
#import "EnvironmentSubActivity+Complete.h"

@interface FTINEnvironmentActivityViewController ()
{
	FTINEnvironmentSubActivityContent *_content;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *organizationBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *narrationBarButton;

- (IBAction)showOrganizationChoices:(UIBarButtonItem *)sender;
- (IBAction)showNarrationChoices:(UIBarButtonItem *)sender;

@property (nonatomic, strong) FTINCoherenceChoiceViewController *organizationViewController;
@property (nonatomic, strong) FTINCoherenceChoiceViewController *narrationViewController;

@end

@implementation FTINEnvironmentActivityViewController

#pragma mark - Super methods

- (void)dealloc
{
	_content = nil;
	_organizationViewController = nil;
	_narrationViewController = nil;
	_organizationBarButton = nil;
	_narrationBarButton = nil;
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
			 self.organizationBarButton,
			 fixedSpace,
			 self.narrationBarButton
			 ];
}

- (BOOL)prepareToGoToNextActivity
{
	EnvironmentSubActivity *data = (id) self.subActivity.data;
	
	if(self.organizationViewController.hasSelectedChoice)
	{
		data.organizationCoherence = self.organizationViewController.selectedCoherence;
	}
	
	if(self.narrationViewController.hasSelectedChoice)
	{
		data.narrationCoherence = self.narrationViewController.selectedCoherence;
	}
	
#warning TODO terminar de setar os role;
	
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
