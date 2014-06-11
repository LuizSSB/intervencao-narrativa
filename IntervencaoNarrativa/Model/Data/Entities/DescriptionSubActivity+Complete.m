//
//  DescriptionSubActivity+Complete.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/07.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "DescriptionSubActivity+Complete.h"

@implementation DescriptionSubActivity (Complete)

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
		*error = [NSError ftin_createErrorWithCode:ftin_InvalidDataErrorCode];
		return NO;
	}
	
	return YES;
}

@end
