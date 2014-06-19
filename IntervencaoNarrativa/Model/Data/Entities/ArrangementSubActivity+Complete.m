//
//  ArrangementSubActivity+Complete.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/10.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "ArrangementSubActivity+Complete.h"

@implementation ArrangementSubActivity (Complete)

- (FTINNarrativeSkill)narrativeSkill
{
	return (FTINNarrativeSkill) self.narrativeSkillNumber.integerValue;
}

- (void)setNarrativeSkill:(FTINNarrativeSkill)narrativeSkill
{
	self.narrativeSkillNumber = @(narrativeSkill);
}

- (FTINArrangementSkill)arrangementSkill
{
	return (FTINArrangementSkill) self.arrangementSkillNumber.integerValue;
}

- (void)setArrangementSkill:(FTINArrangementSkill)arrangementSkill
{
	self.arrangementSkillNumber = @(arrangementSkill);
}

- (BOOL)valid:(NSError *__autoreleasing *)error
{
	do
	{
		if(!self.narrativeSkillNumber) break;
		if(self.narrativeSkillNumber.integerValue < 0) break;
		if(self.narrativeSkill > FTINNarrativeSkillIncompetentFool) break;
		
		if(!self.arrangementSkillNumber) break;
		if(self.arrangementSkillNumber.integerValue < 0) break;
		if(self.arrangementSkill > FTINArrangementSkillHelped) break;
		
		return YES;
	}
	while (NO);
	
	[NSError ftin_createErrorWithCode:ftin_PerformanceDataMissingErrorCode inReference:error];
	return NO;
}

@end
