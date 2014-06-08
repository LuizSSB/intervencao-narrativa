//
//  FTINActivityFlowController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/06.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityFlowController.h"
#import "FTINActivityController.h"
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
		_dataController = [[FTINActivityController alloc] init];
	}
	
	return _dataController;
}

#pragma mark - Sub activity iteration

- (BOOL)hasNextSubActivity
{
	return _currentActivityIdx + 1 < self.activity.subActivities.count;
}

- (FTINSubActivityDetails *)nextSubActivity
{
	return self.activity.subActivities[++_currentActivityIdx];
}

#pragma mark - Data control

- (BOOL)start:(NSError *__autoreleasing *)error
{
	FTINActivityDetails *activity = [self.dataController activityDetailsWithContentsOfURL:self.activityUrl error:error];
	
	if(!*error)
	{
		if(activity.subActivities.count)
		{
			_currentActivityIdx = -1;
			_activity = activity;
			return YES;
		}
		else
		{
			*error = [NSError ftin_createErrorWithCode:ftin_InvalidActivityErrorCode];
		}
	}
	
	return NO;
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
		[self.dataController saveSubActivity:subActivity resultHandler:^(id result, NSError *error) {
			[self.delegate activityFlowController:self savedSubActivity:result error:error];
		}];
	}
}

- (void)finish
{
	[self.dataController saveActivity:self.activity forPatient:self.patient resultHandler:^(id result, NSError *error) {
		[self.delegate activityFlowController:self savedActivity:result error:error];
	}];
}

- (void)cancel
{
	[self.dataController cancelActivity:self.activity resultHandler:^(id result, NSError *error) {
		[self.delegate activityFlowController:self canceledActivity:result error:error];
	}];
}

@end
