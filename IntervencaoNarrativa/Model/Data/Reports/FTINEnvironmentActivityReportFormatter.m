//
//  FTINEnvironmentSubActivityReportFormatter.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/07/20.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINEnvironmentActivityReportFormatter.h"
#import "FTINEnumPropertyDefinition.h"

#import "EnvironmentSubActivity+Complete.h"

@implementation FTINEnvironmentActivityReportFormatter

#pragma mark - Super methods

- (NSString *)templateResourceName
{
	return @"EnvironmentActivityReportTemplate";
}

- (NSArray *)enumPropertiesDefinitions
{
	return @[
			 [FTINEnumPropertyDefinition definitionWithOptions:@[
																 @(FTINCoherenceOrganized),
																 @(FTINCoherenceUnorganized)
																 ]
													   keyPath:NSStringFromSelector(@selector(organizationCoherence))
											 templateKeyPrefix:@"organizationSkill_"
			  ],
			 [FTINEnumPropertyDefinition definitionWithOptions:@[
																 @(FTINCoherenceOrganized),
																 @(FTINCoherenceUnorganized)
																 ]
													   keyPath:NSStringFromSelector(@selector(narrationCoherence))
											 templateKeyPrefix:@"narrationSkill_"
			  ]
			 ];
}

- (void)customizeContext:(NSMutableDictionary *)context forActivities:(NSArray *)activities
{
	context[@"selectedElements"] = [NSMutableArray array];
	context[@"unselectedElements"] = [NSMutableArray array];
	
	for (EnvironmentSubActivity *activity in activities)
	{
		[context[@"selectedElements"] addObject:@{
												  @"selectedElement":[activity.selectedElementsNames.allObjects componentsJoinedByString:@", "]
												  }];
		
		[context[@"unselectedElements"] addObject:@{
												  @"unselectedElement":[activity.unselectedElementsNames.allObjects componentsJoinedByString:@", "]
												  }];
	}
}

@end
