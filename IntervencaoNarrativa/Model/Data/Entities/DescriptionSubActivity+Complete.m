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
	return (FTINDescriptiveSkill) self.descriptiveSkillInteger.integerValue;
}

- (void)setDescriptiveSkill:(FTINDescriptiveSkill)descriptiveSkill
{
	self.descriptiveSkillInteger = @(descriptiveSkill);
}

- (BOOL)valid:(NSError *__autoreleasing *)error
{
	if(!self.descriptiveSkillInteger || self.descriptiveSkillInteger.integerValue < 0)
	{
		*error = [NSError ftin_createErrorWithCode:ftin_InvalidDataErrorCode];
		return NO;
	}
	
	return YES;
}

@end
