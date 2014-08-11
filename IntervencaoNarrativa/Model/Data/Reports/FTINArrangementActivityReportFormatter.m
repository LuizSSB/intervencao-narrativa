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

NSString * const FTINArrangementActivityTemplateName = @"ArrangementActivityReportTemplate";

@implementation FTINArrangementActivityReportFormatter

#pragma mark - Super methods

- (NSString *)templateResourceName
{
	return FTINArrangementActivityTemplateName;
}

- (NSArray *)enumPropertiesDefinitions
{
	return @[
			 [FTINEnumPropertyDefinition definitionWithOptions:@[
																 @(FTINNarrativeSkillNoHelp),
																 @(FTINNarrativeSkillLottaHelp),
																 @(FTINNarrativeSkillPartialHelp),
																 @(FTINNarrativeSkillIncompetentFool)
																 ]
													   keyPath:NSStringFromSelector(@selector(narrativeSkill))
											 templateKeyPrefix:@"narrationSkill_"],
			 [FTINEnumPropertyDefinition definitionWithOptions:@[
																 @(FTINArrangementSkillNoHelp),
																 @(FTINArrangementSkillHelped),
																 ]
													   keyPath:NSStringFromSelector(@selector(arrangementSkill))
											 templateKeyPrefix:@"arrangementSkill_"]
			 ];
}

@end
