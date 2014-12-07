//
//  FTINReportFormatter.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINReportFormatter.h"
#import "FTINActitivitiesFactory.h"
#import "FTINActivityReportFormatter.h"
#import "FTINTemplateUtils.h"

#import "Activity+Complete.h"
#import "SubActivity+Complete.h"

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

- (NSString *)createReportForActivitiesOfType:(FTINActivityType)type error:(NSError *__autoreleasing *)error
{
	id<FTINActivityReportFormatter> formatter = [[[FTINActitivitiesFactory classBasedOnSubActivityType:type withSuffix:@"ActivityReportFormatter"] alloc] init];
	NSArray *activities = [self.activity subActivitiesOfType:type];
	NSString *formatted = [formatter formatActivities:activities error:error];
	
	return formatted;
}

- (NSString *)createScoreReportWithError:(NSError *__autoreleasing *)error
{
	NSMutableDictionary *context = [NSMutableDictionary dictionary];
	context[@"totalScore"] = self.activity.formattedTotalScore;
	
	NSMutableArray *subActivitiesContexts = [NSMutableArray array];
	
	for (NSNumber *typeNumber in FTINActivityTypeGetValues())
	{
		FTINActivityType type = typeNumber.integerValue;
		
		NSMutableArray *subActivities = [NSMutableArray array];
		
		[[self.activity subActivitiesOfType:type] enumerateObjectsUsingBlock:^(SubActivity *obj, NSUInteger idx, BOOL *stop) {
			[subActivities addObject:@{
									   @"id":@(idx + 1),
									   @"score":obj.formattedScore,
									   @"state":obj.skipped ? FTINHTMLClassSkipped : [NSString string]
									   }
			 ];
		}];
		
		[subActivitiesContexts addObject:@{
										   @"type":FTINActivityTypeTitle(type),
										   @"totalScore":[self.activity formattedTotalScoreOfSubActivitiesOfType:type],
										   @"activities":subActivities
										   }];
	}
	context[@"subActivities"] = subActivitiesContexts;
	
	NSURL *templateUrl = [[NSBundle mainBundle] URLForResource:@"ScoreReportTemplate" withExtension:@"html"];
	return [FTINTemplateUtils parseTemplate:templateUrl withContext:context error:error];
}

@end
