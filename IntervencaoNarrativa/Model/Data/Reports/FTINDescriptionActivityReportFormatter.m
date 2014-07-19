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

- (NSString *)templateResourceName
{
	return @"DescriptionActivityReportTemplate";
}

- (NSArray *)enumPropertiesDefinitions
{
	return @[
			 [FTINEnumPropertyDefinition definitionWithOptions:@[
																 @(FTINDescriptiveSkillNoHelp),
																 @(FTINDescriptiveSkillLottaHelp),
																 @(FTINDescriptiveSkillPartialHelp),
																 @(FTINDescriptiveSkillIncompetentFool),
																 ]
													   keyPath:NSStringFromSelector(@selector(descriptiveSkill))
											 templateKeyPrefix:@"descriptionSkill_"]
			 ];
}

@end
