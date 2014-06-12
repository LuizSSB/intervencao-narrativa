//
//  FTINActivityFlowController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/06.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityFlowController.h"
#import "FTINActivityDetails.h"

@interface FTINActivityFlowController ()
{
	NSInteger _currentActivityIdx;
}

@property (nonatomic, readonly) FTINActivityController *dataController;

@end

@implementation FTINActivityFlowController

#pragma mark - Super methods

- (void)dealloc
{
	_activity = nil;
	_activityUrl = nil;
	_patient = nil;
}

#pragma mark - Instance methods

- (instancetype)initWithActivityInFile:(NSURL *)activityUrl andPatient:(Patient *)patient andDelegate:(id<FTINActivityFlowControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
		_activityUrl = activityUrl;
		_patient = patient;
		self.delegate = delegate;
    }
    return self;
}

@synthesize dataController = _dataController;

- (FTINActivityController *)dataController
{
	if(!_dataController)
	{
		_dataController = [[FTINActivityController alloc] initWithDelegate:self];
	}
	
	return _dataController;
}

#pragma mark - Sub activity iteration

- (BOOL)started
{
	return _activity != nil;
}

- (BOOL)hasNextSubActivity
{
	return _currentActivityIdx + 1 < self.activity.subActivities.count;
}

- (FTINSubActivityDetails *)nextSubActivity
{
	return self.activity.subActivities[++_currentActivityIdx];
}

#pragma mark - Data control

- (void)start
{
	[self.dataController loadActivityWithContentsOfURL:self.activityUrl];
}

- (void)saveSubActivity:(FTINSubActivityDetails *)subActivity
{
	if(subActivity != self.activity.subActivities[_currentActivityIdx])
	{
		NSError *error = [NSError ftin_createErrorWithCode:ftin_InvalidSubActivityErrorCode];
		[self.delegate activityFlowController:self savedSubActivity:subActivity error:error];
	}
	else
	{
		[self.dataController saveSubActivity:subActivity];
	}
}

- (void)finish
{
	[self.dataController saveActivity:self.activity forPatient:self.patient];
}

- (void)cancel
{
	[self.dataController cancelActivity:self.activity];
}

#pragma mark - Activity Controller Delegate

- (void)activityController:(FTINActivityController *)controller loadedActivity:(FTINActivityDetails *)activity error:(NSError *)error
{
	if(!error)
	{
		if(activity.subActivities.count)
		{
			_currentActivityIdx = -1;
			_activity = activity;
		}
		else
		{
			error = [NSError ftin_createErrorWithCode:ftin_InvalidActivityErrorCode];
		}
	}
	
	return [self.delegate activityFlowController:self startedWithError:error];
}

- (void)activityController:(FTINActivityController *)controller savedSubActivity:(FTINSubActivityDetails *)subActivity error:(NSError *)error
{
	[self.delegate activityFlowController:self savedSubActivity:subActivity error:error];
}

- (void)activityController:(FTINActivityController *)controller savedActivity:(FTINActivityDetails *)activity error:(NSError *)error
{
	[self.delegate activityFlowController:self savedActivity:activity error:error];
}

- (void)activityController:(FTINActivityController *)controller canceledActivity:(FTINActivityDetails *)activity error:(NSError *)error
{
	[self.delegate activityFlowController:self canceledActivity:activity error:error];
}

@end
