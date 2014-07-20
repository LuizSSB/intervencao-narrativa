//
//  FTINJsonActivity.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/05.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityDetails.h"
#import "FTINSubActivityDetails.h"

#import "Activity+Complete.h"
#import "SubActivity+Complete.h"

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

- (NSArray *)getDataToInsert
{
	NSMutableArray *dataToInsert = [NSMutableArray arrayWithObject:self.data];
	NSString *arrayClass = NSStringFromClass([NSArray class]);
	NSString *setClass = NSStringFromClass([NSSet class]);
	
	for (SubActivity *sub in self.data.subActivities)
	{
		[dataToInsert addObject:sub];
		
		NSDictionary *props = sub.objectProperties;
		
		for (NSString *prop in props.allKeys)
		{
			NSString *propType = props[prop];
			
			if([propType rangeOfString:arrayClass].location != NSNotFound || [propType rangeOfString:setClass].location != NSNotFound)
			{
				for (id subProp in [sub valueForKey:prop])
				{
					[dataToInsert addObject:subProp];
				}
			}
		}
	}
	
	return dataToInsert;
}

@end
