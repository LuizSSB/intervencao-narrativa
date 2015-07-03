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

NSInteger const FTINMaximumActivitiesTries = 3;
NSInteger const FTINMinimumActivityCompletionToSkip = 2;

NSString const * kFTINViewedActivityBaseName = @"viewed_activity_";

@interface FTINActivityFlowController ()
{
	NSInteger _currentActivityIdx;
	NSMutableArray *_skippingSubActivities;
	BOOL _autoSkipping;
	Activity *_activityData;
}

@property (nonatomic, readonly) FTINActivityController *dataController;
@property (nonatomic, readonly) BOOL canSkipCurrentDifficultyLevel;

+ (NSString *)keyForViewedActivityOfType:(FTINActivityType)type;
- (void)_skipLevelOfSubActivity:(FTINSubActivityDetails *)subActivity;
- (void)finishSkippingActivitiesLike:(FTINSubActivityDetails *)subactivity withError:(NSError *)error;

@end

@implementation FTINActivityFlowController

#pragma mark - Super methods

- (void)dealloc
{
	_activity = nil;
	_activityUrl = nil;
	_patient = nil;
	[_skippingSubActivities removeAllObjects];
	_skippingSubActivities = nil;
}

#pragma mark - Instance methods

- (instancetype)initWithActivityInFile:(NSURL *)activityUrl andPatient:(Patient *)patient andDelegate:(id<FTINActivityFlowControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
		_activityUrl = activityUrl;
		_activityData = nil;
		_patient = patient;
		self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithActivit:(Activity *)activity andDelegate:(id<FTINActivityFlowControllerDelegate>)delegate
{
	self = [super init];
	if (self) {
		_activityUrl = nil;
		_activityData = activity;
		_patient = activity.patient;
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
	return [self.activity subActivitiesThatRespond:^BOOL(FTINSubActivityDetails *subActivity) {
		return !subActivity.data.done;
	}].count;
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
	
	if(nextSubActivity.data.done)
	{
		return [self nextSubActivity];
	}
	
	return nextSubActivity;
}

- (FTINSubActivityDetails *)jumpToSubActivityAtIndex:(NSUInteger)activityIndex
{
	NSAssert(activityIndex < self.activity.subActivities.count, @"error_ftin_3005".localizedString);
	
	_currentActivityIdx = activityIndex;
	FTINSubActivityDetails *nextSubActivity = self.activity.subActivities[activityIndex];
	
	if(nextSubActivity.data.status == FTINActivityStatusSkipped)
	{
		nextSubActivity.data.status = FTINActivityStatusIncomplete;
	}
	
	return nextSubActivity;
}

- (void)jumpToSubActivity:(FTINSubActivityDetails *)subActivity
{
	[self jumpToSubActivityAtIndex:[self.activity.subActivities indexOfObject:subActivity]];
}

#pragma mark - User defaults

- (BOOL)viewedInstructionsForActivityType:(FTINActivityType)type
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:[FTINActivityFlowController keyForViewedActivityOfType:type]];
}

- (void)setViewedInstructions:(BOOL)viewed forActivityType:(FTINActivityType)type
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:viewed forKey:[FTINActivityFlowController keyForViewedActivityOfType:type]];
	[defaults synchronize];
}

+ (NSString *)keyForViewedActivityOfType:(FTINActivityType)type
{
	return [kFTINViewedActivityBaseName stringByAppendingFormat:@"%ld", (long) type];
}

#pragma mark - Data control

- (void)start
{
	if(self.activityUrl)
	{
		_currentActivityIdx = -1;
		[self.dataController loadActivityWithContentsOfURL:self.activityUrl];
	}
	else
	{
		_currentActivityIdx = _activityData.currentActivityIndex - 1;
		[self.dataController loadUnfinishedActivity:_activityData];
		_activityData = nil;
	}
}

- (void)startWithUnfinishedActivity:(Activity *)activity
{
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

- (void)skipLevelOfSubActivity:(FTINSubActivityDetails *)subActivity
{
	_autoSkipping = NO;
	[self _skipLevelOfSubActivity:subActivity];
}

- (void)_skipLevelOfSubActivity:(FTINSubActivityDetails *)subActivity
{
	_skippingSubActivities = [NSMutableArray arrayWithArray:[self.activity subActivitiesThatRespond:^BOOL(FTINSubActivityDetails *aSubActivity) {
		return aSubActivity.type == subActivity.type && aSubActivity.difficultyLevel == subActivity.difficultyLevel && !aSubActivity.data.done;
	}]];
	
	if(_skippingSubActivities.count)
	{
		[self.dataController skipSubActivity:_skippingSubActivities[0]];
	}
	else
	{
		[self finishSkippingActivitiesLike:subActivity withError:nil];
	}
}

- (void)finishSkippingActivitiesLike:(FTINSubActivityDetails *)subActivity withError:(NSError *)error
{
	for (FTINSubActivityDetails *sub in self.activity.subActivities)
	{
		if(!sub.data.done)
		{
			[self nextSubActivity];
			--_currentActivityIdx;
			
			[_skippingSubActivities removeAllObjects];
			_skippingSubActivities = nil;
			[self.delegate activityFlowController:self skippedSubActivitiesOfType:subActivity.type andDifficultyLevel:subActivity.difficultyLevel automatically:_autoSkipping error:error];
			return;
		}
	}
	
	[self finish];
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

- (void)fail
{
	[self.dataController failActivity:self.activity forPatient:self.patient];
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

#pragma mark - Activity Controller Delegate

- (void)activityController:(FTINActivityController *)controller loadedActivity:(FTINActivityDetails *)activity error:(NSError *)error
{
	if(!error)
	{
		if(activity.subActivities.count)
		{
			_activity = activity;
		}
		else
		{
			_activity = nil;
			error = [NSError ftin_createErrorWithCode:FTINErrorCodeInvalidActivity];
		}
	}
	
	return [self.delegate activityFlowController:self startedWithError:error];
}

- (void)activityController:(FTINActivityController *)controller completedSubActivity:(FTINSubActivityDetails *)subActivity error:(NSError *)error
{
	if(self.canSkipCurrentDifficultyLevel && subActivity.data.tries == 0 && !error)
	{
		NSArray *levelSubActivities = [self.activity subActivitiesOfType:subActivity.type difficultyLevel:subActivity.difficultyLevel];
		NSInteger correctSubActivities = 0;
		
		for (FTINSubActivityDetails *levelSubActivity in levelSubActivities)
		{
			if(levelSubActivity.data.done)
			{
				if(levelSubActivity.data.tries)
				{
					break;
				}
				else if(++correctSubActivities >= FTINMinimumActivityCompletionToSkip)
				{
					_autoSkipping = YES;
					[self _skipLevelOfSubActivity:subActivity];
				}
			}
		}
	}

	[self.delegate activityFlowController:self completedSubActivity:subActivity error:error];
	
	if(subActivity.data.tries >= 3)
	{
		[self.dataController failSubActivity:subActivity];
	}
}

- (void)activityController:(FTINActivityController *)controller skippedSubActivity:(FTINSubActivityDetails *)subActivity error:(NSError *)error
{
	if(!error)
	{
		[_skippingSubActivities removeObjectAtIndex:0];
		
		if(_skippingSubActivities.count)
		{
			[self.dataController skipSubActivity:_skippingSubActivities[0]];
			return;
		}
	}
	
	if(error || !_skippingSubActivities.count)
	{
		[self finishSkippingActivitiesLike:subActivity withError:error];
	}
}

- (void)activityController:(FTINActivityController *)controller failedSubActivity:(FTINSubActivityDetails *)subActivity error:(NSError *)error
{
	[self.delegate activityFlowController:self failedSubActivity:subActivity error:error];
}

- (void)activityController:(FTINActivityController *)controller finalizedActivity:(FTINActivityDetails *)activity error:(NSError *)error
{
	[self.delegate activityFlowController:self finishedActivity:activity error:error];
}

- (void)activityController:(FTINActivityController *)controller canceledActivity:(FTINActivityDetails *)activity error:(NSError *)error
{
	[self.delegate activityFlowController:self canceledActivity:activity error:error];
}

- (void)activityController:(FTINActivityController *)controller failedActivity:(FTINActivityDetails *)activity error:(NSError *)error
{
	[self.delegate activityFlowController:self failedActivity:activity error:error];
}

- (void)activityController:(FTINActivityController *)controller pausedActivity:(FTINActivityDetails *)activity error:(NSError *)error
{
	[self.delegate activityFlowController:self pausedActivity:activity error:error];
}

@end
