//
//  FTINActivityNavigationController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/07.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityNavigationController.h"
#import "FTINActivityInstructionViewController.h"
#import "FTINActivityViewControllerFactory.h"
#import "FTINSubActivitiesTableViewController.h"

#import "FTINSubActivityDetails.h"
#import "Activity+Complete.h"
#import "SubActivity+Complete.h"

NSInteger const FTINAlertViewTagDoSkippedActivity = 1;
NSInteger const FTINAlertViewTagContinueAfterFailing = 2;
NSInteger const FTINAlertViewTagLoopActivities = 3;

@interface FTINActivityNavigationController () <FTINSubActivitiesTableViewControllerDelegate, UIAlertViewDelegate>
{
	FTINSubActivityDetails *_pendingSubActivity;
	UIViewController *_parentViewController;
	FTINActivityFlowController *_controller;
}

@property (nonatomic, readonly) FTINSubActivitiesTableViewController *activitiesViewController;
@property (nonatomic, readonly) FTINActivityViewController *currentActivityViewController;

+ (UIColor *)defaultViewControllerBackground;
+ (UIViewController *)createUselessRootViewController;

- (void)goToNextSubActivity;
- (void)goToSubActivity:(FTINSubActivityDetails *)subactivity animated:(BOOL)animated;

@end

@implementation FTINActivityNavigationController

#pragma mark - Super methods

- (void)dealloc
{
	_controller = nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.viewControllers[0] navigationItem].backBarButtonItem = nil;
}

#pragma mark - Instance methods

@synthesize delegate = _delegate;

- (instancetype)initWithActivity:(NSURL *)activityFile andPatient:(Patient *)patient andDelegate:(id<FTINActivityNavigationControllerDelegate, UINavigationControllerDelegate>)delegate
{
    self = [super initWithRootViewController:[FTINActivityNavigationController createUselessRootViewController]];
    if (self) {
		self.delegate = delegate;
		_controller = [[FTINActivityFlowController alloc] initWithActivityInFile:activityFile andPatient:patient andDelegate:self];
    }
    return self;
}

- (instancetype)initWithUnfinishedActivity:(Activity *)activity andDelegate:(id<FTINActivityNavigationControllerDelegate,UINavigationControllerDelegate>)delegate
{
	self = [super initWithRootViewController:[FTINActivityNavigationController createUselessRootViewController]];
	if(self)
	{
		self.delegate = delegate;
		_controller = [[FTINActivityFlowController alloc] initWithActivit:activity andDelegate:self];
	}
	return self;
}

@synthesize activitiesViewController = _activitiesViewController;
- (FTINSubActivitiesTableViewController *)activitiesViewController
{
	if(!_activitiesViewController)
	{
		_activitiesViewController = [[FTINSubActivitiesTableViewController alloc] initWithActivity:_controller.activity andDelegate:self];
	}
	
	return _activitiesViewController;
}

- (FTINActivityViewController *)currentActivityViewController
{
	return self.viewControllers.count > 1 ? (FTINActivityViewController *)self.viewControllers.lastObject : nil;
}

+ (UIColor *)defaultViewControllerBackground
{
	return [UIColor whiteColor];
}

+ (UIViewController *)createUselessRootViewController
{
	UIViewController *viewController = [[UIViewController alloc] init];
	viewController.view.backgroundColor = [self defaultViewControllerBackground];
	return viewController;
}

- (void)goToNextSubActivity
{
	[_controller requestNextSubActivity];
}

- (void)goToSubActivity:(FTINSubActivityDetails *)subactivity animated:(BOOL)animated
{
	void (^pushNextActivity)() = ^void() {
		void (^deFactoPushNextActivity)(BOOL) = ^void(BOOL animatedPush){
			[self popToRootViewControllerAnimated:NO];
			
			FTINActivityViewController *nextViewController = [FTINActivityViewControllerFactory activityViewControllerForSubActivity:subactivity withDelegate:self];
			[self pushViewController:nextViewController animated:animatedPush];
		};
		
		if([_controller viewedInstructionsForActivityType:subactivity.type])
		{
			deFactoPushNextActivity(animated);
		}
		else
		{
			UIViewController *instructionsViewController = [[FTINActivityInstructionViewController alloc] initWithActivityType:subactivity.type];
			instructionsViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
			[self presentViewController:instructionsViewController animated:YES completion:^{
				[_controller setViewedInstructions:YES forActivityType:subactivity.type];
				deFactoPushNextActivity(NO);
			}];
		}
	};
	
	__block FTINActivityViewController *currentActivityViewController = self.currentActivityViewController;
	if(currentActivityViewController)
	{
		currentActivityViewController.view.superview.backgroundColor = [FTINActivityNavigationController defaultViewControllerBackground];
		[UIView animateWithDuration:FTINDefaultAnimationShortDuration animations:^{
			currentActivityViewController.view.layer.opacity = 0.f;
			currentActivityViewController = nil;
		} completion:^(BOOL finished) {
			pushNextActivity();
		}];
	}
	else
	{
		pushNextActivity();
	}
}

- (void)loadAndPresentFomViewController:(UIViewController *)parentViewController
{
	_parentViewController = parentViewController;
	[_controller start];
}

#pragma mark - Activity View Controller Delegate

- (void)activityViewControllerFinished:(FTINActivityViewController *)viewController
{
	[_controller completeSubActivity:viewController.subActivity];
}

- (void)activityViewControllerCanceled:(FTINActivityViewController *)viewController
{
	[_controller cancel];
}

- (UIBarButtonItem *)activityViewControllerCustomizedNextBarButton:(FTINActivityViewController *)viewController
{
	return _controller.incompleteActivities > 1 ? nil : [[UIBarButtonItem alloc] initWithTitle:@"finalize".localizedString style:UIBarButtonItemStyleDone target:nil action:nil];
}

- (void)activityViewControllerSkipped:(FTINActivityViewController *)viewController
{
	[_controller skipLevelOfSubActivity:viewController.subActivity];
}

- (void)activityViewControllerPaused:(FTINActivityViewController *)viewController
{
	[_controller pauseInSubActivity:viewController.subActivity];
}

- (void)activityViewControllerMustShowActivityList:(FTINActivityViewController *)viewController
{
	[self.activitiesViewController presentAsPopoverFromRect:self.navigationBar.topItem.titleView.frame inView:self.navigationBar animated:YES];
}

#pragma mark - Activity Flow Controller Delegate

- (void)activityFlowController:(FTINActivityFlowController *)controller startedWithError:(NSError *)error
{
	if([NSError alertOnError:error andDoOnSuccess:^{
		[_parentViewController presentViewController:self animated:YES completion:^{
			_parentViewController = nil;
			[self goToNextSubActivity];
		}];
	}])
	{
		[self.delegate activityNavigationController:self failed:error];
	};
}

- (void)activityFlowController:(FTINActivityFlowController *)controller completedSubActivity:(FTINSubActivityDetails *)details error:(NSError *)error
{
	if(error)
	{
		if([error.domain isEqualToString:FTINErrorDomainSubActivity])
		{
			[self showToastText:error.localizedDescription withImage:[UIImage imageNamed:FTINToastFailureImage]];
		}
		else
		{
			[self showToastText:error.localizedDescription];
		}
	}
	else
	{
		if(details.data.executed)
		{
			[self showLocalizedToastText:@"success" withImage:[UIImage imageNamed:FTINToastSuccessImage]];
		}
		
		[self goToNextSubActivity];
	}
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
	NSString *msg;
	
	if (!automatically)
	{
		[self goToNextSubActivity];
		msg = @"skipped";
	}
	else
	{
		msg = @"autoskipped";
	}
	
	[self showLocalizedToastText:msg withImage:[UIImage imageNamed:FTINToastSkipImage]];
}

- (void)activityFlowController:(FTINActivityFlowController *)controller failedSubActivity:(FTINSubActivityDetails *)subActivity error:(NSError *)error
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"confirmation".localizedString message:@"exit_after_failing".localizedString delegate:self cancelButtonTitle:@"see_answer".localizedString otherButtonTitles:@"continue".localizedString, nil];
	alert.tag = FTINAlertViewTagContinueAfterFailing;
	[alert show];
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

- (void)activityFlowController:(FTINActivityFlowController *)controller gotNextSubActivity:(FTINSubActivityDetails *)nextSubActivity looped:(BOOL)looped error:(NSError *)error
{
	if(error)
	{
		NSAssert(error.code == FTINErrorCodeNoMoreActivitiesLeft, @"An error that should have happened just leaked.");
		[_controller finish];
	}
	else if(looped)
	{
		_pendingSubActivity = nextSubActivity;
		
		UIAlertView *loopAlert = [[UIAlertView alloc] initWithTitle:@"confirm".localizedString message:@"wanna_loop".localizedString delegate:self cancelButtonTitle:@"back".localizedString otherButtonTitles:@"finish_process".localizedString, nil];
		loopAlert.tag = FTINAlertViewTagLoopActivities;
		[loopAlert show];
	}
	else
	{
		[self goToSubActivity:nextSubActivity animated:YES];
	}
}

#pragma mark - Sub Activities Table View Controller Delegate

- (void)subActivitiesViewController:(FTINSubActivitiesTableViewController *)viewController selectedSubActivity:(FTINSubActivityDetails *)subActivity atIndex:(NSUInteger)index
{
	[viewController dismissPopoverAnimated:YES];
	
	if(_controller.currentSubActivity != subActivity)
	{
		if(subActivity.data.status == FTINActivityStatusSkipped)
		{
			_pendingSubActivity = subActivity;
			
			UIAlertView *alert = [UIAlertView alertWithConfirmation:@"do_skipped_activity".localizedString delegate:self];
			alert.tag = FTINAlertViewTagDoSkippedActivity;
			[alert show];
		}
		else
		{
			[_controller jumpToSubActivityAtIndex:index];
			[self goToSubActivity:subActivity animated:YES];
		}
	}
}

- (BOOL)subActivitesViewController:(FTINSubActivitiesTableViewController *)viewController shouldMarkSubActivity:(FTINSubActivityDetails *)subActivity atIndex:(NSUInteger)index
{
	return subActivity == _controller.currentSubActivity;
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag == FTINAlertViewTagDoSkippedActivity)
	{
		if(buttonIndex != alertView.cancelButtonIndex)
		{
			[_controller jumpToSubActivity:_pendingSubActivity];
			[self goToSubActivity:_pendingSubActivity animated:YES];
		}
		
		_pendingSubActivity = nil;
	}
	else if(alertView.tag == FTINAlertViewTagContinueAfterFailing)
	{
		if(buttonIndex == alertView.cancelButtonIndex)
		{
			[self.currentActivityViewController showAnswer];
		}
		else
		{
			[self goToNextSubActivity];
		}
	}
	else if(alertView.tag == FTINAlertViewTagLoopActivities)
	{
		if(buttonIndex == alertView.cancelButtonIndex)
		{
			[self goToSubActivity:_pendingSubActivity animated:YES];
		}
		else
		{
			[_controller finish];
		}
		
		_pendingSubActivity = nil;
	}
}

@end
