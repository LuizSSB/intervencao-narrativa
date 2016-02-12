//
//  FTINActivityController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/08.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityController.h"
#import "FTINActitivitiesFactory.h"
#import "FTINActivityDetails.h"
#import "FTINSubActivityDetails.h"

#import "DCModel.h"
#import "Activity+Complete.h"
#import "SubActivity+Complete.h"
#import "Patient+Complete.h"

NSInteger const FTINMaximumActivitiesTries = 3;

@interface FTINActivityDetails()

- (void)loadActivityDetailsFromURL:(NSURL *)url resultHandler:(FTINOperationHandler)resultHandler;
- (BOOL)loadActivity:(FTINActivityDetails *)activity error:(NSError **)error;
- (BOOL)loadSubActivity:(FTINSubActivityDetails *)subActivity error:(NSError **)error;

- (void)saveActivity:(FTINActivityDetails *)activity withPatient:(Patient *)patient resultHandler:(FTINOperationHandler)resultHandler;

- (void)deleteActivity:(Activity *)activity resultHandler:(FTINOperationHandler)resultHandler;

@end

@implementation FTINActivityController

#pragma mark - Instance methods

- (instancetype)initWithDelegate:(id<FTINActivityControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)loadActivityDetailsFromURL:(NSURL *)url resultHandler:(FTINOperationHandler)resultHandler
{
	NSError *error = nil;
	FTINActivityDetails *activity = nil;
	
	do
	{
		NSString *json = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
		
		if(error) break;
		
		JSONModelError *jsonError = nil;
		activity = [[FTINActivityDetails alloc] initWithString:json error:&jsonError];
		
		if (jsonError) {
			error = jsonError;
			break;
		}
		
		[self loadActivity:activity error:&error];
	}
	while(NO);
	
	resultHandler(activity, error);
}

// TODO Luiz: tornar assíncrono
- (void)loadActivityWithContentsOfURL:(NSURL *)fileUrl
{
	[self loadActivityDetailsFromURL:fileUrl resultHandler:^(FTINActivityDetails *result, NSError *error) {
		if(!error)
		{
			result.data = [Activity newObject];
			result.data.title = result.title;
			result.data.baseFile = fileUrl.pathComponents.lastObject;
			
			for (FTINSubActivityDetails *subActivity in result.subActivities)
			{
				subActivity.data = [FTINActitivitiesFactory subActivityDataOfType:subActivity.type];
				subActivity.data.creationDate = [NSDate date];
				subActivity.data.parentActivity = result.data;
				[subActivity.data setupWithContent:subActivity.content];
				[result.data addSubActivitiesObject:subActivity.data];
			}
		}
		
		[self.delegate activityController:self loadedActivity:result error:error];
	}];
}

// TODO Luiz: tornar assíncrono
- (void)loadUnfinishedActivity:(Activity *)activity
{
	[self loadActivityDetailsFromURL:activity.baseFileUrl resultHandler:^(FTINActivityDetails *result, NSError *error) {
		if(!error)
		{
			result.data = activity;
			
			NSArray *subActivities = activity.subActivitesInOrder;
			NSInteger subActIdx = 0;
			
			for (FTINSubActivityDetails *subActivitiesDetails in result.subActivities)
			{
				subActivitiesDetails.data = subActivities[subActIdx++];
			}
		}
		
		[self.delegate activityController:self loadedActivity:result error:error];
	}];
}

- (BOOL)loadActivity:(FTINActivityDetails *)activity error:(NSError *__autoreleasing *)error
{
	for (FTINSubActivityDetails *subactivity in activity.subActivities)
	{
		if(![self loadSubActivity:subactivity error:error])
		{
			return NO;
		}
		
		subactivity.parentActivity = activity;
	}
	
	return YES;
}

- (BOOL)loadSubActivity:(FTINSubActivityDetails *)subActivity error:(NSError *__autoreleasing *)error
{
	NSString *contentExtension = [[subActivity.contentFile componentsSeparatedByString:@"."] lastObject];
	NSString *contentName = [subActivity.contentFile substringToIndex:[subActivity.contentFile rangeOfString:[@"." stringByAppendingString:contentExtension]].location];
	
	NSURL *contentUrl = [[NSBundle mainBundle] URLForResource:contentName withExtension:contentExtension];
	
	if(!contentUrl)
	{
		contentUrl = [NSURL fileURLWithPath:subActivity.contentFile];
	}
	
	subActivity.content = [FTINActitivitiesFactory subActivityContentOfType:subActivity.type withContentsofURL:contentUrl error:error];
	
	return !*error;
}

// TODO Luiz: no momento, não é necessário, mas, no futuro, provavelmente será assíncrono.
- (void)completeSubActivity:(FTINSubActivityDetails *)subActivity
{
	NSError *error = nil;
	
	if(!subActivity.data.finished)
	{
		if([subActivity valid:&error])
		{
			subActivity.data.status = FTINActivityStatusCompleted;
		}
		else
		{
			if([error.domain isEqualToString:FTINErrorDomainSubActivity])
			{
				if(++subActivity.data.tries >= FTINMaximumActivitiesTries)
				{
					subActivity.data.status = FTINActivityStatusFailed;
				}
			}
			else
			{
				subActivity.data.status = FTINActivityStatusIncomplete;
			}
		}
	}
	
	[self.delegate activityController:self completedSubActivity:subActivity error:error];
}

- (void)skipSubActivities:(NSArray *)subActivities
{
	NSError *error = nil;
	
	for (FTINSubActivityDetails *subActivity in subActivities)
	{
		if(!subActivity.skippable)
		{
			error = [NSError ftin_createErrorWithCode:FTINErrorCodeNonSkippableSubActivity];
		}
	}
	
	if(!error)
	{
		for (FTINSubActivityDetails *subActivity in subActivities)
		{
			if(!subActivity.data.executed)
			{
				subActivity.data.status = FTINActivityStatusSkipped;
			}
		}
	}
	
	[self.delegate activityController:self skippedSubActivities:subActivities error:error];
}

- (void)finalizeActivity:(FTINActivityDetails *)activity forPatient:(Patient *)patient
{
	for (SubActivity *sub in activity.data.subActivities)
	{
#warning FIXME
		if(!sub.executed)
		{
			[self.delegate activityController:self finalizedActivity:activity error:[NSError ftin_createErrorWithCode:FTINErrorCodeNotAllSubActivitiesCompleted]];
			return;
		}
	}
	
	activity.data.finalized = YES;
	[self saveActivity:activity withPatient:patient resultHandler:^(id result, NSError *error) {
		[self.delegate activityController:self finalizedActivity:activity error:error];
	}];
}

- (void)pauseActivity:(FTINActivityDetails *)activity inSubActivity:(NSInteger)subActivityIndex forPatient:(Patient *)patient
{
	activity.data.finalized = NO;
	activity.data.currentActivityIndex = subActivityIndex;
	
	[self saveActivity:activity withPatient:patient resultHandler:^(id result, NSError *error) {
		[self.delegate activityController:self pausedActivity:activity error:error];
	}];
}

- (void)failActivity:(FTINActivityDetails *)activity forPatient:(Patient *)patient
{
	activity.data.failed = YES;
	[self saveActivity:activity withPatient:patient resultHandler:^(id result, NSError *error) {
		[self.delegate activityController:self failedActivity:activity error:error];
	}];
}

- (void)saveActivity:(FTINActivityDetails *)activity withPatient:(Patient *)patient resultHandler:(FTINOperationHandler)resultHandler
{
	NSArray *dataToInsert = [activity getDataToInsert];
	
	void (^errorHandler)(NSError *) = ^(NSError *error)
	{
		resultHandler(nil, error);
	};
	
	[Activity saveObjects:dataToInsert success:^(id items) {
		if(activity.data.patient)
		{
			errorHandler(nil);
		}
		else
		{
			activity.data.patient = patient;
			[activity.data.patient addActivitiesObject:activity.data];
			
			[Activity saveObjects:@[activity.data, activity.data.patient] success:^(id items) {
				errorHandler(nil);
			} failure:errorHandler];
		}
	} failure:errorHandler];
}

- (void)cancelActivity:(FTINActivityDetails *)activity
{
	[self deleteActivity:activity.data resultHandler:^(id result, NSError *error) {
		[self.delegate activityController:self canceledActivity:activity error:error];
	}];
}

- (void)deleteActivity:(Activity *)activity
{
	[self deleteActivity:activity resultHandler:^(id result, NSError *error) {
		[self.delegate activityController:self deletedActivity:activity error:error];
	}];
}

- (void)deleteActivity:(Activity *)activity resultHandler:(FTINOperationHandler)resultHandler
{
	NSMutableArray *subActivitiesData = [NSMutableArray arrayWithObject:activity];
	[subActivitiesData addObjectsFromArray:activity.subActivitesInOrder];
	
	[SubActivity destroyObjects:subActivitiesData success:^{
		resultHandler(activity, nil);
	} failure:^(NSError *error) {
		resultHandler(activity, error);
	}];
}

@end
