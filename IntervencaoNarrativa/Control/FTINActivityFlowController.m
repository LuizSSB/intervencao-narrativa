//
//  FTINActivityFlowController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/06.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityFlowController.h"
#import "FTINActivityDetails.h"

#import "Activity+Complete.h"
#import "SubActivity+Complete.h"

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

- (FTINSubActivityDetails *)currentSubActivity
{
	if(_currentActivityIdx >= 0 && _currentActivityIdx < self.activity.subActivities.count)
	{
		return self.activity.subActivities[_currentActivityIdx];
	}
	
	return nil;
}

- (NSUInteger)incompleteActivities
{
	NSUInteger total = 0;
	
	for (FTINSubActivityDetails *sub in self.activity.subActivities)
	{
		if(!sub.data.completed)
		{
			++total;
		}
	}
	
	return total;
}

- (BOOL)hasNextSubActivity
{
	return self.incompleteActivities > 0;
}

- (FTINSubActivityDetails *)nextSubActivity
{
	if(++_currentActivityIdx >= self.activity.subActivities.count)
	{
		_currentActivityIdx = 0;
	}
	
	FTINSubActivityDetails *nextSubActivity = self.activity.subActivities[_currentActivityIdx];
	
	if(nextSubActivity.data.completed)
	{
		[self resetLevelData];
		return [self nextSubActivity];
	}
	
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

- (FTINSubActivityDetails *)jumpToSubActivityAtIndex:(NSUInteger)activityIndex
{
	NSAssert(activityIndex < self.activity.subActivities.count, @"error_ftin_3005".localizedString);
	
	[self resetLevelData];
	
	_currentActivityIdx = activityIndex;
	FTINSubActivityDetails *nextSubActivity = self.activity.subActivities[activityIndex];
	
	if(nextSubActivity.data.skipped)
	{
		nextSubActivity.data.completed = NO;
	}
	
	return nextSubActivity;
}

- (void)jumpToSubActivity:(FTINSubActivityDetails *)subActivity
{
	[self jumpToSubActivityAtIndex:[self.activity.subActivities indexOfObject:subActivity]];
}

#pragma mark - Data control

- (void)start
{
	_currentActivityIdx = -1;
	[self.dataController loadActivityWithContentsOfURL:self.activityUrl];
}

- (void)startWithUnfinishedActivity:(Activity *)activity
{
	_currentActivityIdx = activity.currentActivityIndex - 1;
	[self.dataController loadUnfinishedActivity:activity];
}

- (void)completeSubActivity:(FTINSubActivityDetails *)subActivity
{
	if(subActivity != self.activity.subActivities[_currentActivityIdx])
	{
		NSError *error = [NSError ftin_createErrorWithCode:FTINErrorCodeInvalidSubActivity];
		[self.delegate activityFlowController:self completedSubActivity:subActivity error:error];
	}
	else
	{
		[self.dataController completeSubActivity:subActivity];
	}
}

- (void)skipSubActivity:(FTINSubActivityDetails *)subActivity
{
	if(subActivity != self.activity.subActivities[_currentActivityIdx])
	{
		NSError *error = [NSError ftin_createErrorWithCode:FTINErrorCodeInvalidSubActivity];
		[self.delegate activityFlowController:self completedSubActivity:subActivity error:error];
	}
	else
	{
		_lastSavedSubActivity = subActivity;
		[self.dataController skipSubActivity:subActivity];
	}
}

- (void)finish
{
	[self.dataController finalizeActivity:self.activity forPatient:self.patient];
}

- (void)pauseInSubActivity:(FTINSubActivityDetails *)subActivity
{
	if(subActivity != self.activity.subActivities[_currentActivityIdx])
	{
		NSError *error = [NSError ftin_createErrorWithCode:FTINErrorCodeInvalidSubActivity];
		[self.delegate activityFlowController:self pausedActivity:self.activity error:error];
	}
	else
	{
		[self.dataController pauseActivity:self.activity inSubActivity:_currentActivityIdx forPatient:self.patient];
	}
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
	
	[self.delegate activityFlowController:self completedSubActivity:_lastSavedSubActivity error:nil];
}

#pragma mark - Activity Controller Delegate

- (void)activityController:(FTINActivityController *)controller loadedActivity:(FTINActivityDetails *)activity error:(NSError *)error
{
	if(!error)
	{
		if(activity.subActivities.count)
		{
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

- (void)activityController:(FTINActivityController *)controller completedSubActivity:(FTINSubActivityDetails *)subActivity error:(NSError *)error
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
	
	[self.delegate activityFlowController:self completedSubActivity:subActivity error:error];
}

- (void)activityController:(FTINActivityController *)controller skippedSubActivity:(FTINSubActivityDetails *)subActivity error:(NSError *)error
{	
	[self.delegate activityFlowController:self skippedSubActivity:subActivity error:error];
	
	if(error)
	{
		[self.delegate activityFlowController:self completedSubActivity:_lastSavedSubActivity error:nil];
	}
	else
	{
		[self checkIfCanSkipNextActivity];
	}
}

- (void)activityController:(FTINActivityController *)controller finalizedActivity:(FTINActivityDetails *)activity error:(NSError *)error
{
	[self.delegate activityFlowController:self finishedActivity:activity error:error];
}

- (void)activityController:(FTINActivityController *)controller canceledActivity:(FTINActivityDetails *)activity error:(NSError *)error
{
	[self.delegate activityFlowController:self canceledActivity:activity error:error];
}

- (void)activityController:(FTINActivityController *)controller pausedActivity:(FTINActivityDetails *)activity error:(NSError *)error
{
	[self.delegate activityFlowController:self pausedActivity:activity error:error];
}

@end
