//
//  WhyGameQuestion+Complete.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/07/16.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "WhyGameQuestion+Complete.h"

@implementation WhyGameQuestion (Complete)

- (BOOL)answered
{
	return self.answerSkillNumber != nil;
}

- (FTINAnswerSkill)answerSkill
{
	return (FTINAnswerSkill) self.answerSkillNumber.integerValue;
}

- (void)setAnswerSkill:(FTINAnswerSkill)answerSkill
{
	self.answerSkillNumber = @(answerSkill);
}

@end
