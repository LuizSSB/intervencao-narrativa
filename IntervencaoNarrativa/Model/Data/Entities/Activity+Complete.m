//
//  Acitivity+Complete.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/07.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "Activity+Complete.h"
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

- (NSURL *)baseFileUrl
{
	NSArray *baseFileComponents = [self.baseFile componentsSeparatedByString:@"."];
	return [[NSBundle mainBundle] URLForResource:baseFileComponents[0] withExtension:baseFileComponents[1]];
}

- (CGFloat)totalScore
{
	CGFloat score = 0;
	NSArray *types = FTINActivityTypeGetValues();
	CGFloat nonSkippedTypes = 0;
	
	for (NSNumber *type in types)
	{
		CGFloat typeScore = [self totalScoreOfSubActivitiesOfType:type.integerValue];
		
		if(typeScore != FTINActivityScoreSkipped)
		{
			score += typeScore;
			++nonSkippedTypes;
		}
	}
	
	return score / nonSkippedTypes;
}

- (NSString *)formattedTotalScore
{
	return @(self.totalScore).scoreValue;
}

- (CGFloat)totalScoreOfSubActivitiesOfType:(FTINActivityType)type
{
	NSArray *subActivities = [self subActivitiesOfType:type];
	CGFloat score = 0;
	CGFloat nonSkippedActivities = 0;
	
	for (SubActivity *sub in subActivities)
	{
		if(!sub.skipped)
		{
			score += sub.score;
			++nonSkippedActivities;
		}
	}
	
	return nonSkippedActivities ? score / nonSkippedActivities : FTINActivityScoreSkipped;
}

- (NSString *)formattedTotalScoreOfSubActivitiesOfType:(FTINActivityType)type
{
	return @([self totalScoreOfSubActivitiesOfType:type]).scoreValue;
}

@end
