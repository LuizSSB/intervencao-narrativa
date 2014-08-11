//
//  FTINReportFormatter.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINReportFormatter.h"
#import "FTINActitivitiesFactory.h"
#import "Activity+Complete.h"
#import "FTINActivityReportFormatter.h"

@implementation FTINReportFormatter

#pragma mark - Super methods

- (void)dealloc
{
	_activity = nil;
}

#pragma mark - Instance methods

- (instancetype)initWithActivity:(Activity *)activity
{
    self = [super init];
    if (self) {
        self.activity = activity;
    }
    return self;
}

- (NSString *)createReportActivitiesOfType:(FTINActivityType)type error:(NSError *__autoreleasing *)error
{
	id<FTINActivityReportFormatter> formatter = [[[FTINActitivitiesFactory classBasedOnSubActivityType:type withSuffix:@"ActivityReportFormatter"] alloc] init];
	NSArray *activities = [self.activity subActivitiesOfType:type];
	NSString *formatted = [formatter formatActivities:activities error:error];
	
	return formatted;
}

@end
