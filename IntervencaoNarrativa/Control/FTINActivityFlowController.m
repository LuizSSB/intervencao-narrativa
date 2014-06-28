//
//  FTINActivityFlowController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/06.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityFlowController.h"
#import "FTINActivityDetails.h"

NSInteger const FTINMinimumActivityCompletionToSkip = 2;

@interface FTINActivityFlowController ()
{
	NSInteger _currentActivityIdx;
	
	BOOL _userFailedInLevel;
	NSInteger _completedActivitiesInLevel;
	FTINSubActivityDetails *_lastSavedSubActivity;
}

@property (nonatomic, readonly) FTINActivityController *dataController;
@property (nonatomic, readonly) BOOL canSkipCurrentDifficultyLevel;

- (void)resetLevelData;
- (void)checkIfCanSkipNextActivity;

@end

@implementation FTINActivityFlowController

#pragma mark - Super methods

- (void)dealloc
{
	_activity = nil;
	_activityUrl = nil;
	_patient = nil;
	_lastSavedSubActivity = nil;
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
	FTINSubActivityDetails *nextSubActivity = self.activity.subActivities[++_currentActivityIdx];
	
	if(_currentActivityIdx > 0)
	{
		FTINSubActivityDetails *currentSubActivity = self.activity.subActivities[_currentActivityIdx - 1];
		
		if(currentSubActivity.type != nextSubActivity.type || currentSubActivity.difficultyLevel != nextSubActivity.difficultyLevel)
		{
			[self resetLevelData];
		}
	}
	
	return nextSubActivity;
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
		NSError *error = [NSError ftin_createErrorWithCode:FTINErrorCodeInvalidSubActivity];
		[self.delegate activityFlowController:self savedSubActivity:subActivity error:error];
	}
	else
	{
		[self.dataController saveSubActivity:subActivity];
	}
}

- (void)skipSubActivity:(FTINSubActivityDetails *)subActivity
{
	if(subActivity != self.activity.subActivities[_currentActivityIdx])
	{
		NSError *error = [NSError ftin_createErrorWithCode:FTINErrorCodeInvalidSubActivity];
		[self.delegate activityFlowController:self savedSubActivity:subActivity error:error];
	}
	else
	{
		_lastSavedSubActivity = subActivity;
		[self checkIfCanSkipNextActivity];
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

- (BOOL)canSkipCurrentDifficultyLevel
{
	FTINSubActivityDetails *subActivity = self.activity.subActivities[_currentActivityIdx];
	return subActivity.allowsAutoSkip;
}

- (void)resetLevelData
{
	_completedActivitiesInLevel = 0;
	_userFailedInLevel = NO;
}

- (void)checkIfCanSkipNextActivity
{
	NSArray *subActivities = self.activity.subActivities;
	
	if(_currentActivityIdx + 1 < subActivities.count)
	{
		FTINSubActivityDetails *curSubAct = subActivities[_currentActivityIdx];
		FTINSubActivityDetails *nextSubAct = subActivities[_currentActivityIdx + 1];
		
		if(curSubAct.type == nextSubAct.type && curSubAct.difficultyLevel == nextSubAct.difficultyLevel)
		{
			++_currentActivityIdx;
			[self.dataController skipSubActivity:nextSubAct];
			return;
		}
	}
	
	[self.delegate activityFlowController:self savedSubActivity:_lastSavedSubActivity error:nil];
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
			[self resetLevelData];
		}
		else
		{
			error = [NSError ftin_createErrorWithCode:FTINErrorCodeInvalidActivity];
		}
	}
	
	return [self.delegate activityFlowController:self startedWithError:error];
}

- (void)activityController:(FTINActivityController *)controller savedSubActivity:(FTINSubActivityDetails *)subActivity error:(NSError *)error
{
	if(self.canSkipCurrentDifficultyLevel)
	{
		if([error.domain isEqualToString:FTINErrorDomainSubActivity])
		{
			_userFailedInLevel = YES;
		}
		else if(!error && !_userFailedInLevel && ++_completedActivitiesInLevel >= FTINMinimumActivityCompletionToSkip)
		{
			_lastSavedSubActivity = subActivity;
			[self checkIfCanSkipNextActivity];
			return;
		}
	}
	
	[self.delegate activityFlowController:self savedSubActivity:subActivity error:error];
}

- (void)activityController:(FTINActivityController *)controller skippedSubActivity:(FTINSubActivityDetails *)subActivity error:(NSError *)error
{
	if(error)
	{
		[self.delegate activityFlowController:self savedSubActivity:_lastSavedSubActivity error:nil];
	}
	else
	{
		[self checkIfCanSkipNextActivity];
	}
	
	[self.delegate activityFlowController:self skippedSubActivity:subActivity error:error];
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
