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

#import "FTINSfxController.h"

NSString * const FTINSfxReinforceSuccess = @"success";
NSString * const FTINSfxReinforceSuccessLevel = @"success_level";
NSString * const FTINSfxReinforceNope = @"block";
NSString * const FTINSfxReinforceFailure = @"failure";
NSString * const FTINSfxReinforceComplete = @"complete";

NSInteger const FTINMinimumActivityCompletionToSkip = 2;

NSString * const kFTINViewedActivityBaseName = @"viewed_activity_";

@interface FTINActivityFlowController ()
{
	NSInteger _currentActivityIdx;
	Activity *_activityData;
	
	BOOL _isAutoSkipingActivities;
	FTINSubActivityDetails *_autoAkippingSubActivity;
}

@property (nonatomic, readonly) FTINActivityController *dataController;

+ (NSString *)keyForViewedActivityOfType:(FTINActivityType)type;

- (BOOL)shouldSkipLevelOfSubActivity:(FTINSubActivityDetails *)subactivity;

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

- (void)requestNextSubActivity
{
	BOOL looped = NO;
	
	for (int activityIdx = _currentActivityIdx + 1;
		 activityIdx != _currentActivityIdx;
		 ++activityIdx)
	{
		if(activityIdx >= self.activity.subActivities.count)
		{
			activityIdx = 0;
			looped = YES;
		}
		
		FTINSubActivityDetails *nextSubActivity = self.activity.subActivities[activityIdx];
		
		if(!nextSubActivity.data.done)
		{
			_currentActivityIdx = activityIdx;
			
			[self.delegate activityFlowController:self gotNextSubActivity:nextSubActivity looped:looped error:nil];
			return;
		}
	}
	
	NSError *error = [NSError ftin_createErrorWithCode:FTINErrorCodeNoMoreActivitiesLeft];
	[self.delegate activityFlowController:self gotNextSubActivity:nil looped:looped error:error];
}

- (BOOL)shouldSkipLevelOfSubActivity:(FTINSubActivityDetails *)subactivity
{
	if(!subactivity.skippable || !subactivity.allowsAutoSkip)
	{
		return NO;
	}
	
	NSInteger totalDoneActivities = 0;
	NSArray *levelSubActivities = [self.activity subActivitiesOfType:subactivity.type difficultyLevel:subactivity.difficultyLevel];
	
	for (FTINSubActivityDetails *levelSubActivity in levelSubActivities)
	{
		if (levelSubActivity.data.tries)
		{
			return NO;
		}
		
		if (levelSubActivity.data.done
			&& ++totalDoneActivities >= FTINMinimumActivityCompletionToSkip)
		{
			return YES;
		}
	}
	
	return NO;
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
	// Luiz: sanity check to detect bugs when reprogramming this class
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
	NSArray *levelSubActivity = [self.activity subActivitiesOfType:subActivity.type difficultyLevel:subActivity.difficultyLevel];
	[self.dataController skipSubActivities:levelSubActivity];
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
	NSString *sfx;
	
	if (subActivity.data.status == FTINActivityStatusFailed)
	{
		sfx = FTINSfxReinforceFailure;
		[self.delegate activityFlowController:self failedSubActivity:subActivity error:error];
	}
	else
	{
		if([self shouldSkipLevelOfSubActivity:subActivity])
		{
			_isAutoSkipingActivities = YES;
			_autoAkippingSubActivity = subActivity;
			[self skipLevelOfSubActivity:subActivity];
			return;
		}
		else
		{
			sfx = error ? FTINSfxReinforceNope : FTINSfxReinforceSuccess;
			[self.delegate activityFlowController:self completedSubActivity:subActivity error:error];
		}
	}
	
	[[FTINSfxController sharedController] playSfx:sfx ofExtension:FTINSfxDefaultExtension];
}

- (void)activityController:(FTINActivityController *)controller skippedSubActivities:(NSArray *)subActivities error:(NSError *)error
{
	NSAssert(!error || !_isAutoSkipingActivities, @"Failed to auto-akip sub activities");
	
	FTINSubActivityDetails *baseSubActivity = subActivities[0];
	
	if(_isAutoSkipingActivities)
	{
		[self.delegate activityFlowController:self completedSubActivity:_autoAkippingSubActivity error:error];
	}
	
	[self.delegate activityFlowController:self skippedSubActivitiesOfType:baseSubActivity.type andDifficultyLevel:baseSubActivity.difficultyLevel automatically:_isAutoSkipingActivities error:error];
	_isAutoSkipingActivities = NO;
	
	if(self.incompleteActivities > 0)
	{
		[[FTINSfxController sharedController] playSfx:FTINSfxReinforceSuccessLevel ofExtension:FTINSfxDefaultExtension];
	}
}

- (void)activityController:(FTINActivityController *)controller finalizedActivity:(FTINActivityDetails *)activity error:(NSError *)error
{
	if(!error)
	{
		[[FTINSfxController sharedController] playSfx:FTINSfxReinforceComplete ofExtension:FTINSfxDefaultExtension];
	}
	
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
