//
//  Acitivity+Complete.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/07.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "Activity+Complete.h"
#import "SubActivity+Complete.h"

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

- (BOOL)finalized
{
	return self.finalizedNumber.boolValue;
}

- (void)setFinalized:(BOOL)finalized
{
	self.finalizedNumber = @(finalized);
	
	if(!finalized)
	{
		self.failed = NO;
	}
}

- (BOOL)failed
{
	return self.failedNumber.boolValue;
}

- (void)setFailed:(BOOL)failed
{
	self.failedNumber = @(failed);
	
	if(failed)
	{
		self.finalized = YES;
	}
}

- (NSInteger)currentActivityIndex
{
	return self.currentActivityIndexNumber.integerValue;
}

- (void)setCurrentActivityIndex:(NSInteger)currentActivityIndex
{
	self.currentActivityIndexNumber = @(currentActivityIndex);
}

- (SubActivity *)currentActivity
{
	return self.subActivitesInOrder[self.currentActivityIndex];
}

- (void)setCurrentActivity:(SubActivity *)currentActivity
{
	NSInteger index = [self.subActivitesInOrder indexOfObject:currentActivity];
	
	if (index != NSNotFound)
	{
		self.currentActivityIndex = index;
	}
}

@end
