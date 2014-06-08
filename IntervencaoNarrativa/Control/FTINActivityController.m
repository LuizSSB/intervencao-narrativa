//
//  FTINActivityController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/06.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityController.h"
#import "FTINActivityDetails.h"

@interface FTINActivityController ()
{
	NSInteger _currentActivityIdx;
}

@end

@implementation FTINActivityController

#pragma mark - Super methods

- (void)dealloc
{
	_activity = nil;
	_activityUrl = nil;
	_patient = nil;
}

#pragma mark - Instance methods

- (instancetype)initWithActivityInFile:(NSURL *)activityUrl andPatient:(Patient *)patient andDelegate:(id<FTINActivityControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
		_activityUrl = activityUrl;
		_patient = patient;
		self.delegate = delegate;
    }
    return self;
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
	FTINActivityDetails *activity = [FTINActivityDetails activityDetailsWithContentsOfURL:self.activityUrl forPatient:self.patient error:error];
	
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
	NSError *error = nil;
	
	if(subActivity != self.activity.subActivities[_currentActivityIdx])
	{
		error = [NSError ftin_createErrorWithCode:ftin_InvalidSubActivityErrorCode];
	}
	else
	{
		[subActivity save:&error];
	}
	
	[self.delegate activityController:self savedSubActivity:subActivity error:error];
}

- (void)finish
{
	[self.activity save:^(id result, NSError *error) {
		[self.delegate activityController:self savedActivity:result error:error];
	}];
}

- (void)cancel
{
	[self.activity cancel:^(id result, NSError *error) {
		[self.delegate activityController:self canceledActivity:result error:error];
	}];
}

@end
