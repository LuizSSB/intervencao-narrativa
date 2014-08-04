//
//  WhyGameSubActivity+Complete.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "WhyGameSubActivity+Complete.h"
#import "WhyGameQuestion+Complete.h"
#import "DCModel.h"

#import "FTINSubActivityContent.h"
#import "FTINWhyGameSubActivityContent.h"
#import "FTINWhyGameQuestion.h"

@implementation WhyGameSubActivity (Complete)

- (void)setupWithContent:(FTINSubActivityContent *)content
{
	NSArray *questions = ((FTINWhyGameSubActivityContent *)content).questions;
	
	for (FTINWhyGameQuestion *question in questions)
	{
		WhyGameQuestion *questionData = [WhyGameQuestion newObject];
		questionData.question = question.question;
		questionData.answer = question.answer;
		questionData.parentSubActivity = self;
		[self addQuestionsObject:questionData];
	}
}

- (void)setSkill:(FTINAnswerSkill)skill forQuestionWithContent:(FTINWhyGameQuestion *)question
{
	for (WhyGameQuestion *questionData in self.questions)
	{
		if([questionData.question isEqualToString:question.question])
		{
			questionData.answerSkill = skill;
			return;
		}
	}
}

- (NSSet *)getChosenQuestions
{
	NSMutableSet *set = [NSMutableSet set];
	
	for (WhyGameQuestion *question in self.questions)
	{
		if(question.chosen)
		{
			[set addObject:question];
		}
	}
	
	return set;
}

- (void)chooseQuestionWithContent:(FTINWhyGameQuestion *)question
{
	for (WhyGameQuestion *questionData in self.questions)
	{
		if([questionData.question isEqualToString:question.question])
		{
			questionData.chosen = true;
			return;
		}
	}
}

- (void)unchooseAllQuestions
{
	for (WhyGameQuestion *questionData in self.questions)
	{
		questionData.chosen = false;
	}
}

- (BOOL)valid:(NSError *__autoreleasing *)error
{
	if(self.questions.count)
	{		
		for (WhyGameQuestion *question in self.questions)
		{
			if(question.answered)
			{
				return YES;
			}
		}
	}
	
	[NSError ftin_createErrorWithCode:FTINErrorCodePerformanceDataMissing inReference:error];
	return NO;
	
}

@end
