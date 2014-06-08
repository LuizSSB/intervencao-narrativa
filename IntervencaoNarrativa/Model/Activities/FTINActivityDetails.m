//
//  FTINJsonActivity.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/05.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityDetails.h"
#import "FTINSubActivityDetails.h"

#import "DCModel.h"
#import "Activity.h"
#import "SubActivity.h"
#import "Patient.h"

@implementation FTINActivityDetails

#pragma mark - Super methods

- (void)dealloc
{
	self.title = nil;
	self.subActivities = nil;
	self.data = nil;
	self.patient = nil;
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
	return [@[
			  NSStringFromSelector(@selector(data)),
			  NSStringFromSelector(@selector(patient))
			  ] containsObject:propertyName];
}

#pragma mark - Instance methods

- (void)loadOnlyData
{
	self.data = [Activity newObject];
	self.data.title = self.title;
}

- (BOOL)loadEverything:(NSError *__autoreleasing *)error
{
	if(!self.data)
	{
		[self loadOnlyData];
	}
	
	for (FTINSubActivityDetails *subactivity in self.subActivities)
	{
		if(![subactivity load:error])
		{
			return NO;
		}
		
		subactivity.parentActivity = self;
	}
	
	return YES;
}

- (void)save:(FTINOperationResult)result
{
	self.data.finalized = @YES;
	
	NSMutableArray *dataToInsert = [NSMutableArray arrayWithObject:self.data];
	
	for (FTINSubActivityDetails *subs in self.subActivities) {
		[dataToInsert addObject:subs.data];
	}
	
	void (^errorHandler)(NSError *) = ^(NSError *error)
	{
		result(self, error);
	};
	
	[Activity saveObjects:dataToInsert success:^(id items) {
		self.data.patient = self.patient;
		[self.data.patient addActivitiesObject:self.data];
		
		[Activity saveObjects:@[self.data, self.data.patient] success:^(id items) {
			result(self, nil);
		} failure:errorHandler];
	} failure:errorHandler];
}

- (void)cancel:(FTINOperationResult)result
{
	NSMutableArray *subActivitiesData = [NSMutableArray array];

	for (FTINSubActivityDetails *subs in self.subActivities) {
		[subActivitiesData addObject:subs.data];
	}
	
	[SubActivity destroyObjects:subActivitiesData success:^{
		self.subActivities = nil;
		
		[Activity destroyObject:self.data success:^{
			
			result(self, nil);
			
		} failure:^(NSError *error) {
			
			// OH FUCK
			result(self, error);
		}];
		
	} failure:^(NSError *error) {
		
		//OH SHIT
		result(self, error);
	}];
}

#pragma mark - Helper constructors

+ (FTINActivityDetails *)activityDetailsWithContentsOfURL:(NSURL *)fileUrl forPatient:(Patient *)patient error:(NSError *__autoreleasing *)error
{
	do
	{
		NSString *json = [NSString stringWithContentsOfURL:fileUrl encoding:NSUTF8StringEncoding error:error];
		
		if(*error) break;
		
		JSONModelError *jsonError = nil;
		FTINActivityDetails *activity = [[FTINActivityDetails alloc] initWithString:json error:&jsonError];
		
		if (jsonError) {
			*error = jsonError;
			break;
		}
		
		[activity loadEverything:error];
		
		if(*error) break;
		
		activity.patient = patient;
		
		return activity;
	}
	while(NO);
	
	return nil;
}


@end
