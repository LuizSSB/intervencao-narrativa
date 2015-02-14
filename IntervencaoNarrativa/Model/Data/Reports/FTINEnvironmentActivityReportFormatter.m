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
	FTINEnumPropertyDefinition *organizationSkillDef = [FTINEnumPropertyDefinition new];
	organizationSkillDef.title = @"coherence_organization_title".localizedString;
	organizationSkillDef.enumKeyPath = NSStringFromSelector(@selector(organizationCoherenceNumber));;
	organizationSkillDef.enumOptions = FTINCoherenceSkillGetValues();
	organizationSkillDef.enumValueLocalizedPrefix = @"coherenceskill";
	
	FTINEnumPropertyDefinition *narrationSkillDef = [FTINEnumPropertyDefinition new];
	narrationSkillDef.title = @"coherence_narration_title".localizedString;
	narrationSkillDef.enumKeyPath = NSStringFromSelector(@selector(narrationCoherenceNumber));
	narrationSkillDef.enumOptions = organizationSkillDef.enumOptions;
	narrationSkillDef.enumValueLocalizedPrefix = @"coherenceskill";
	
	return @[organizationSkillDef, narrationSkillDef];
}

- (void)customizeContext:(NSMutableDictionary *)context forActivities:(NSArray *)activities
{
	NSMutableArray *activitiesContexts = [NSMutableArray array];
	context[@"activities"] = activitiesContexts;
	
	[activities enumerateObjectsUsingBlock:^(EnvironmentSubActivity *obj, NSUInteger idx, BOOL *stop) {
		[activitiesContexts addObject:@{
										@"id":obj.representativeImagePath,
										@"selectedElements":[obj.selectedElementsNames.allObjects componentsJoinedByString:FTINHTMLElementSeparator],
										@"unselectedElements":[obj.unselectedElementsNames.allObjects componentsJoinedByString:FTINHTMLElementSeparator]
										}];
	}];
}

@end
