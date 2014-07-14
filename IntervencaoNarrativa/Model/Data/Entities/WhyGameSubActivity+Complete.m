//
//  WhyGameSubActivity+Complete.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "WhyGameSubActivity+Complete.h"

@implementation WhyGameSubActivity (Complete)

- (FTINAnswerSkill)answerSkill
{
	return (FTINAnswerSkill) self.answerSkillNumber.integerValue;
}

- (void)setAnswerSkill:(FTINAnswerSkill)answerSkill
{
	self.answerSkillNumber = @(answerSkill);
}

- (BOOL)valid:(NSError *__autoreleasing *)error
{
	do
	{
		if(!self.answerSkillNumber) break;
		if(self.answerSkillNumber.integerValue < 0) break;
		if(self.answerSkill > FTINAnswerSkillIncompetentFool) break;
		
		return YES;
	}
	while (NO);
	
	[NSError ftin_createErrorWithCode:FTINErrorCodePerformanceDataMissing inReference:error];
	return NO;
}

@end
