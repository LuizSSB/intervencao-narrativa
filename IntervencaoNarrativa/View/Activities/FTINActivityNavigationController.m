//
//  FTINActivityNavigationController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/07.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityNavigationController.h"
#import "FTINActivityViewControllerFactory.h"

@interface FTINActivityNavigationController ()
{
	NSError *_pendingError;
}

@property (nonatomic, readonly) FTINActivityFlowController *controller;

- (void)goToNextSubActivity:(BOOL)animated;

@end

@implementation FTINActivityNavigationController

#pragma mark - Super methods

- (void)dealloc
{
	_activityFile = nil;
	_controller = nil;
	_patient = nil;
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

- (void)goToNextSubActivity:(BOOL)animated
{
	[self popToRootViewControllerAnimated:NO];
	
	FTINSubActivityDetails *nextActivity = [self.controller nextSubActivity];
	FTINActivityViewController *nextViewController = [FTINActivityViewControllerFactory activityViewControllerForSubActivity:nextActivity withDelegate:self];
	[self pushViewController:nextViewController animated:YES];
}

#pragma mark - Activity View Controller Delegate

- (void)activityViewControllerFinished:(FTINActivityViewController *)viewController
{
	[self.controller saveSubActivity:viewController.subActivity];
}

- (void)activityViewControllerCanceled:(FTINActivityViewController *)viewController
{
	[self.controller cancel];
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

- (void)activityFlowController:(FTINActivityFlowController *)controller savedSubActivity:(FTINSubActivityDetails *)details error:(NSError *)error
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

- (void)activityFlowController:(FTINActivityFlowController *)controller savedActivity:(FTINActivityDetails *)details error:(NSError *)error
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

@end
