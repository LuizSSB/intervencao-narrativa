//
//  FTINDescriptionActivityReportFormatter.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/07/18.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINDescriptionActivityReportFormatter.h"
#import "FTINEnumPropertyDefinition.h"

#import "DescriptionSubActivity+Complete.h"

@implementation FTINDescriptionActivityReportFormatter

#pragma mark - Super methods

- (NSArray *)enumPropertiesDefinitions
{
	FTINEnumPropertyDefinition *def = [FTINEnumPropertyDefinition new];
	def.title = @"descriptionskill_title".localizedString;
	def.enumKeyPath = NSStringFromSelector(@selector(descriptiveSkillNumber));
	def.difficultyName = @"descriptionskill_difficulty".localizedString;
	def.enumOptions = FTINDescriptiveSkillGetValues();
	def.enumValueLocalizedPrefix = @"descriptionskill";
	return @[def];
}

@end
