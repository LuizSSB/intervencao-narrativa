//
//  FTINArrangementActivityReportFormatter.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINArrangementActivityReportFormatter.h"
#import "FTINEnumPropertyDefinition.h"

#import "ArrangementSubActivity+Complete.h"

@implementation FTINArrangementActivityReportFormatter

#pragma mark - Super methods

- (NSArray *)enumPropertiesDefinitions
{
	FTINEnumPropertyDefinition *organizationSkillDef = [FTINEnumPropertyDefinition new];
	organizationSkillDef.title = @"arrangeskill_title".localizedString;
	organizationSkillDef.enumKeyPath = NSStringFromSelector(@selector(arrangementSkillNumber));
	organizationSkillDef.difficultyName = @"narrationskill_difficulty".localizedString;
	organizationSkillDef.enumOptions = FTINArrangementSkillGetValues();
	organizationSkillDef.enumValueLocalizedPrefix = @"arrangeskill";
	
	FTINEnumPropertyDefinition *narrationSkillDef = [FTINEnumPropertyDefinition new];
	narrationSkillDef.title = @"narrationskill_title".localizedString;
	narrationSkillDef.enumKeyPath = NSStringFromSelector(@selector(narrativeSkillNumber));
	narrationSkillDef.difficultyName = @"narrationskill_difficulty".localizedString;
	narrationSkillDef.enumOptions = FTINNarrativeSkillGetValues();
	narrationSkillDef.enumValueLocalizedPrefix = @"narrationskill";
	
	return @[organizationSkillDef, narrationSkillDef];
}

@end
