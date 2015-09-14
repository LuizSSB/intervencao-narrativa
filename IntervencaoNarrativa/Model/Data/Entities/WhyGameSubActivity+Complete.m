//
//  WhyGameSubActivity+Complete.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "WhyGameSubActivity+Complete.h"

#import "FTINWhyGameQuestion.h"

@implementation WhyGameSubActivity (Complete)

- (NSSet *)chosenQuestions
{
	NSMutableSet *set = [NSMutableSet set];
	
	[self.questions enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
		if([obj chosen])
		{
			[set addObject:obj];
		}
	}];
	
	return set;
}

- (BOOL)valid:(NSError *__autoreleasing *)error
{
	if(!self.chosenQuestions.count)
	{
		[NSError ftin_createErrorWithCode:FTINErrorCodeNoQuestionChosen inReference:error];
		return NO;
	}
	
	return YES;
}

- (CGFloat)calculateScore
{
	CGFloat score = 0;
	NSSet *chosenQuestions = self.chosenQuestions;
	NSInteger numberOfQuestions = 0;
	
	for (FTINWhyGameQuestion *question in chosenQuestions)
	{
		if(question.answered)
		{
			score += FTINAnswerSkillGetScore(question.answerSkill);
			++numberOfQuestions;
		}
	}
	
	return score / (CGFloat) numberOfQuestions;
}

@end
