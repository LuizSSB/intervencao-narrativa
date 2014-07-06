//
//  FTINJsonActivity.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/05.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityDetails.h"
#import "Activity+Complete.h"
#import "FTINSubActivityDetails.h"

@implementation FTINActivityDetails

#pragma mark - Super methods

- (void)dealloc
{
	self.data = nil;
	self.title = nil;
	self.subActivities = nil;
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

- (void)setTitle:(NSString *)title
{
	_title = title;
	
	if(self.data)
	{
		self.data.title = title;
	}
}

- (void)setData:(Activity *)data
{
	_data = data;
	
	if(!data.title.length)
	{
		data.title = self.title;
	}
}

- (NSArray *)subActivitiesOfType:(FTINActivityType)type difficultyLevel:(NSInteger)difficultyLevel
{
	return [self subActivitiesThatRespond:^BOOL(FTINSubActivityDetails *subActivity) {
		return subActivity.type == type && difficultyLevel == subActivity.difficultyLevel;
	}];
}

- (NSArray *)subActivitiesThatRespond:(BOOL (^)(FTINSubActivityDetails *))handler
{
	NSMutableArray *subActivities = [NSMutableArray array];
	
	for (FTINSubActivityDetails *sub in self.subActivities)
	{
		if(handler(sub))
		{
			[subActivities addObject:sub];
		}
	}
	
	return subActivities;
}

@end
