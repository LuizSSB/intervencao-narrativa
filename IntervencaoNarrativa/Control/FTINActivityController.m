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

@interface FTINActivityDetails()

- (void)loadActivityDetailsFromURL:(NSURL *)url resultHandler:(FTINOperationHandler)resultHandler;
- (BOOL)loadActivity:(FTINActivityDetails *)activity error:(NSError **)error;
- (BOOL)loadSubActivity:(FTINSubActivityDetails *)subActivity error:(NSError **)error;
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
			result.data.baseFile = fileUrl.description;
			
			for (FTINSubActivityDetails *subActivity in result.subActivities)
			{
				subActivity.data = [FTINActitivitiesFactory subActivityDataOfType:subActivity.type];
			}
		}
		
		[self.delegate activityController:self loadedActivity:result error:error];
	}];
}

- (void)loadUnfinishedActivity:(Activity *)activity
{
	[self loadActivityDetailsFromURL:[NSURL URLWithString:activity.baseFile] resultHandler:^(FTINActivityDetails *result, NSError *error) {
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

// TODO Luiz: no momento, não é necessário, mas, no futuro, provavelmente será
// assíncrono.
- (void)saveSubActivity:(FTINSubActivityDetails *)subActivity
{
	NSError *error = nil;
	
	if([subActivity valid:&error])
	{
		subActivity.data.parentActivity = subActivity.parentActivity.data;
		[subActivity.data.parentActivity addSubActivitiesObject:subActivity.data];
	}
	
	subActivity.data.skipped = NO;
	[self.delegate activityController:self savedSubActivity:subActivity error:error];
}

- (void)skipSubActivity:(FTINSubActivityDetails *)subActivity
{
	NSError *error = nil;
	
	if(!subActivity.skippable)
	{
		error = [NSError ftin_createErrorWithCode:FTINErrorCodeNonSkippableSubActivity];
	}
	else
	{
		subActivity.data.skipped = YES;
		subActivity.data.parentActivity = subActivity.parentActivity.data;
		[subActivity.data.parentActivity addSubActivitiesObject:subActivity.data];
	}
	
	[self.delegate activityController:self skippedSubActivity:subActivity error:error];
}

- (void)saveActivity:(FTINActivityDetails *)activity forPatient:(Patient *)patient
{
	activity.data.finalized = YES;
	
	NSMutableArray *dataToInsert = [NSMutableArray arrayWithObject:activity.data];
	
	for (FTINSubActivityDetails *subs in activity.subActivities) {
		[dataToInsert addObject:subs.data];
	}
	
	void (^errorHandler)(NSError *) = ^(NSError *error)
	{
		[self.delegate activityController:self savedActivity:activity error:error];
	};
	
	[Activity saveObjects:dataToInsert success:^(id items) {
		activity.data.patient = patient;
		[activity.data.patient addActivitiesObject:activity.data];
		
		[Activity saveObjects:@[activity.data, activity.data.patient] success:^(id items) {
			errorHandler(nil);
		} failure:errorHandler];
	} failure:errorHandler];
}

- (void)pauseActivity:(FTINActivityDetails *)activity inSubActivity:(NSInteger)subActivityIndex forPatient:(Patient *)patient
{
	activity.data.finalized = NO;
	activity.data.currentActivityIndex = subActivityIndex;
	NSMutableArray *dataToInsert = [NSMutableArray arrayWithObject:activity.data];
	
	for (FTINSubActivityDetails *subs in activity.subActivities) {
		if(!subs.data.parentActivity)
		{
			subs.data.parentActivity = activity.data;
			[activity.data addSubActivitiesObject:subs.data];
		}
		
		[dataToInsert addObject:subs.data];
	}
	
	
	void (^errorHandler)(NSError *) = ^(NSError *error)
	{
		[self.delegate activityController:self pausedActivity:activity error:error];
	};
	
	[Activity saveObjects:dataToInsert success:^(id items) {
		activity.data.patient = patient;
		[activity.data.patient addActivitiesObject:activity.data];
		
		[Activity saveObjects:@[activity.data, activity.data.patient] success:^(id items) {
			errorHandler(nil);
		} failure:errorHandler];
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

	// TODO definir a ligação das subatividades como cascade
	for (SubActivity *subs in activity.subActivities) {
		[subActivitiesData addObject:subs];
	}
	
	[SubActivity destroyObjects:subActivitiesData success:^{
		resultHandler(activity, nil);
	} failure:^(NSError *error) {
		resultHandler(activity, error);
	}];
}

@end
