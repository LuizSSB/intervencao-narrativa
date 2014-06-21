//
//  Acitivity+Complete.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/07.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "Acitivity+Complete.h"
#import "SubActivity+Complete.h"
#import "FTINActitivitiesFactory.h"

@implementation Activity (Complete)

static NSSortDescriptor *_activitySubActivitesSortDescriptor;

- (NSArray *)subActivitesInOrder
{
	@synchronized([self class])
	{
		if(!_activitySubActivitesSortDescriptor)
		{
			_activitySubActivitesSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(creationDate)) ascending:YES];
		}
	}
	
	NSArray *subs = [self.subActivities sortedArrayUsingDescriptors:@[_activitySubActivitesSortDescriptor]];
	return subs;
}

// Aparentemente, o método isKindOfClass: falha com objetos do CoreData.
// Então comparamos string mesmo.
- (NSArray *)subActivitiesOfType:(FTINActivityType)type
{
	Class typeClass = [FTINActitivitiesFactory classBasedOnSubActivityType:type withNamespace:nil andPrefix:nil andSuffix:NSStringFromClass([SubActivity class])];
	NSString *typeClassName = NSStringFromClass(typeClass);
	NSMutableArray *activities = [NSMutableArray array];
	
	for (SubActivity *subActivity in self.subActivitesInOrder)
	{
		if([NSStringFromClass(subActivity.class) isEqualToString:typeClassName])
		{
			[activities addObject:subActivity];
		}
	}
	
	return activities;
}

@end
