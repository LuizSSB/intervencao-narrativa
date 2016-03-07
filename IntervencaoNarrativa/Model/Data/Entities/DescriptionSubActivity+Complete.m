//
//  DescriptionSubActivity+Complete.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/07.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "DescriptionSubActivity+Complete.h"
#import "FTINDescriptionSubActivityContent.h"

@implementation DescriptionSubActivity (Complete)

- (void)setupWithContent:(FTINSubActivityContent *)content
{
	[super setupWithContent:content];
	
	NSAssert([content isKindOfClass:[FTINDescriptionSubActivityContent class]], @"Content deve ser de atividade de descrição!");
	
	self.difficulty = [(FTINDescriptionSubActivityContent *)content elements].count;
}

- (FTINDescriptiveSkill)descriptiveSkill
{
	return (FTINDescriptiveSkill) self.descriptiveSkillNumber.integerValue;
}

- (void)setDescriptiveSkill:(FTINDescriptiveSkill)descriptiveSkill
{
	self.descriptiveSkillNumber = @(descriptiveSkill);
}

- (BOOL)valid:(NSError *__autoreleasing *)error
{
	if(!self.descriptiveSkillNumber || self.descriptiveSkillNumber.integerValue < 0 || self.descriptiveSkillNumber.integerValue > FTINDescriptiveSkillIncompetentFool)
	{
		[NSError ftin_createErrorWithCode:FTINErrorCodePerformanceDataMissing inReference:error];
		return NO;
	}
	
	if(!self.describedElements || !self.describedElements.count)
	{
		[NSError ftin_createErrorWithCode:FTINErrorCodePerformanceDataMissing inReference:error];
		return NO;
	}
	
	return YES;
}

- (CGFloat)calculateScore
{
	NSInteger totalDescribed = self.describedElements.count;
	NSInteger totalUndescribed = self.undescribedElements.count;
	CGFloat objectValue = FTINActivityScoreMax / (CGFloat) (totalDescribed + totalUndescribed);
	CGFloat preliminaryScore = objectValue * totalDescribed;
	return preliminaryScore * FTINDescriptiveSkillGetScoreMultiplier(self.descriptiveSkill);
}

@end
