//
//  FTINActivityNavigationController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/07.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityNavigationController.h"
#import "FTINActivityViewControllerFactory.h"
#import "FTINSubActivitiesTableViewController.h"

#import "FTINSubActivityDetails.h"
#import "Activity+Complete.h"
#import "SubActivity+Complete.h"

NSInteger const FTINAlertViewTagDoSkippedActivity = 1;
NSInteger const FTINAlertViewTagContinueAfterFailing = 2;

@interface FTINActivityNavigationController () <FTINSubActivitiesTableViewControllerDelegate, UIAlertViewDelegate>
{
	NSError *_pendingError;
	FTINSubActivityDetails *_pendingSubActivity;
}

@property (nonatomic, readonly) FTINActivityFlowController *controller;
@property (nonatomic, readonly) FTINSubActivitiesTableViewController *activitiesViewController;

- (void)showActivities:(UIBarButtonItem *)sender;
- (void)goToNextSubActivity:(BOOL)animated;
- (void)goToSubActivity:(FTINSubActivityDetails *)subactivity animated:(BOOL)animated;

@end

@implementation FTINActivityNavigationController

#pragma mark - Super methods

- (void)dealloc
{
	_activityFile = nil;
	_controller = nil;
	_patient = nil;
	_pendingSubActivity = nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if (_pendingError) {
		[self.delegate activityNavigationController:self failed:_pendingError];
	}
	
	[self.viewControllers[0] navigationItem].backBarButtonItem = nil;
}

#pragma mark - Instance methods

@synthesize controller = _controller;
- (FTINActivityFlowController *)controller
{
	if(!_controller)
	{
		_controller = [[FTINActivityFlowController alloc] initWithActivityInFile:self.activityFile andPatient:self.patient andDelegate:self];
	}
	
	return _controller;
}

- (instancetype)initWithActivity:(NSURL *)activityFile andPatient:(Patient *)patient andDelegate:(id<FTINActivityNavigationControllerDelegate, UINavigationControllerDelegate>)delegate
{
    self = [super initWithRootViewController:[[UIViewController alloc] init]];
    if (self) {
        _activityFile = activityFile;
		_patient = patient;
		self.delegate = delegate;
		
		[self.controller start];
    }
    return self;
}

- (instancetype)initWithUnfinishedActivity:(Activity *)activity andDelegate:(id<FTINActivityNavigationControllerDelegate,UINavigationControllerDelegate>)delegate
{
	self = [super initWithRootViewController:[[UIViewController alloc] init]];
	if(self)
	{
		_patient = activity.patient;
		self.delegate = delegate;
		
		[self.controller startWithUnfinishedActivity:activity];
	}
	return self;
}

@synthesize activitiesViewController = _activitiesViewController;

- (FTINSubActivitiesTableViewController *)activitiesViewController
{
	if(!_activitiesViewController)
	{
		_activitiesViewController = [[FTINSubActivitiesTableViewController alloc] initWithActivity:self.controller.activity andDelegate:self];
	}
	
	return _activitiesViewController;
}

- (void)goToNextSubActivity:(BOOL)animated
{
	[self goToSubActivity:[self.controller nextSubActivity] animated:animated];
}

- (void)goToSubActivity:(FTINSubActivityDetails *)subactivity animated:(BOOL)animated
{
	[self popToRootViewControllerAnimated:NO];
	
	FTINActivityViewController *nextViewController = [FTINActivityViewControllerFactory activityViewControllerForSubActivity:subactivity withDelegate:self];
	[self pushViewController:nextViewController animated:animated];
}

- (void)showActivities:(UIBarButtonItem *)sender
{
	[self.activitiesViewController presentAsPopoverFromBarButtonItem:sender animated:YES];
}

#pragma mark - Activity View Controller Delegate

- (void)activityViewControllerFinished:(FTINActivityViewController *)viewController
{
	[self.controller completeSubActivity:viewController.subActivity];
}

- (void)activityViewControllerCanceled:(FTINActivityViewController *)viewController
{
	[self.controller cancel];
}

- (UIBarButtonItem *)activityViewControllerCustomizedNextBarButton:(FTINActivityViewController *)viewController
{
	return self.controller.incompleteActivities > 1 ? nil : [[UIBarButtonItem alloc] initWithTitle:@"finalize".localizedString style:UIBarButtonItemStyleDone target:nil action:nil];
}

- (void)activityViewControllerSkipped:(FTINActivityViewController *)viewController
{
	[self.controller skipLevelOfSubActivity:viewController.subActivity];
}

- (void)activityViewControllerPaused:(FTINActivityViewController *)viewController
{
	[self.controller pauseInSubActivity:viewController.subActivity];
}

- (NSArray *)activityViewControllerAdditionalRightBarButtonItems:(FTINActivityViewController *)viewController
{
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"activities".localizedString style:UIBarButtonItemStyleBordered target:self action:@selector(showActivities:)];
	return @[barButton];
}

#pragma mark - Activity Flow Controller Delegate

- (void)activityFlowController:(FTINActivityFlowController *)controller startedWithError:(NSError *)error
{
	if([NSError alertOnError:error andDoOnSuccess:^{
		_pendingError = nil;
		[self goToNextSubActivity:NO];
	}])
	{
		_pendingError = error;
	};
}

- (void)activityFlowController:(FTINActivityFlowController *)controller completedSubActivity:(FTINSubActivityDetails *)details error:(NSError *)error
{
	[NSError alertOnError:error andDoOnSuccess:^{
		if(self.controller.hasNextSubActivity)
		{
			[self goToNextSubActivity:YES];
		}
		else
		{
			[self.controller finish];
		}
	}];
}

- (void)activityFlowController:(FTINActivityFlowController *)controller finishedActivity:(FTINActivityDetails *)details error:(NSError *)error
{
	[NSError alertOnError:error andDoOnSuccess:^{
		[self.delegate activityNavigationControllerFinished:self];
	}];
}

- (void)activityFlowController:(FTINActivityFlowController *)controller canceledActivity:(FTINActivityDetails *)activity error:(NSError *)error
{
	[NSError alertOnError:error andDoOnSuccess:^{
		[self.delegate activityNavigationControllerCanceled:self];
	}];
}

- (void)activityFlowController:(FTINActivityFlowController *)controller skippedSubActivitiesOfType:(FTINActivityType)type andDifficultyLevel:(NSInteger)difficultyLevel automatically:(BOOL)automatically error:(NSError *)error
{
	if (!automatically)
	{
		[self activityFlowController:controller completedSubActivity:nil error:error];
	}
	else
	{
		[NSError alertOnError:error andDoOnSuccess:nil];
	}
}

- (void)activityFlowController:(FTINActivityFlowController *)controller failedSubActivity:(FTINSubActivityDetails *)subActivity error:(NSError *)error
{
	[NSError alertOnError:error andDoOnSuccess:^{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"confirmation".localizedString message:@"exit_after_failing".localizedString delegate:self cancelButtonTitle:@"cancel".localizedString otherButtonTitles:@"continue".localizedString, nil];
		alert.tag = FTINAlertViewTagContinueAfterFailing;
		[alert show];
	}];
}

- (void)activityFlowController:(FTINActivityFlowController *)controller pausedActivity:(FTINActivityDetails *)activity error:(NSError *)error
{
	[NSError alertOnError:error andDoOnSuccess:^{
		[self.delegate activityNavigationControllerPaused:self];
	}];
}

- (void)activityFlowController:(FTINActivityFlowController *)controller failedActivity:(FTINActivityDetails *)activity error:(NSError *)error
{
	[NSError alertOnError:error andDoOnSuccess:^{
		[self.delegate activityNavigationControllerFinished:self];
	}];
}

#pragma mark - Sub Activities Table View Controller Delegate

- (void)subActivitiesViewController:(FTINSubActivitiesTableViewController *)viewController selectedSubActivity:(FTINSubActivityDetails *)subActivity atIndex:(NSUInteger)index
{
	[viewController dismissPopoverAnimated:YES];
	
	if(self.controller.currentSubActivity != subActivity)
	{
		if(subActivity.data.skipped)
		{
			_pendingSubActivity = subActivity;
			
			UIAlertView *alert = [UIAlertView alertWithConfirmation:@"do_skipped_activity".localizedString delegate:self];
			alert.tag = FTINAlertViewTagDoSkippedActivity;
			[alert show];
		}
		else
		{
			[self.controller jumpToSubActivityAtIndex:index];
			[self goToSubActivity:subActivity animated:YES];
		}
	}
}

- (BOOL)subActivitesViewController:(FTINSubActivitiesTableViewController *)viewController shouldMarkSubActivity:(FTINSubActivityDetails *)subActivity atIndex:(NSUInteger)index
{
	return subActivity == self.controller.currentSubActivity;
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag == FTINAlertViewTagDoSkippedActivity)
	{
		if(buttonIndex != alertView.cancelButtonIndex)
		{
			[self.controller jumpToSubActivity:_pendingSubActivity];
			[self goToSubActivity:_pendingSubActivity animated:YES];
		}
		
		_pendingSubActivity = nil;
	}
	else if(alertView.tag == FTINAlertViewTagContinueAfterFailing)
	{
		if(buttonIndex == alertView.cancelButtonIndex)
		{
			[self.controller fail];
		}
		else
		{
			if(self.controller.hasNextSubActivity)
			{
				[self goToNextSubActivity:YES];
			}
			else
			{
				[self.controller finish];
			}
		}
	}
}

@end
