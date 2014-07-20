//
//  WhyGameSubActivity+Complete.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "WhyGameSubActivity+Complete.h"
#import "WhyGameQuestion+Complete.h"
#import "FTINWhyGameQuestion.h"
#import "DCModel.h"

@implementation WhyGameSubActivity (Complete)

- (void)setQuestionsWithContents:(NSArray *)questions
{
	[self removeQuestions:self.questions];
	
	for (FTINWhyGameQuestion *question in questions)
	{
		WhyGameQuestion *questionData = [WhyGameQuestion newObject];
		questionData.question = question.question;
		questionData.answer = question.answer;
		[self addQuestionsObject:questionData];
	}
}

- (void)setSkill:(FTINAnswerSkill)skill forQuestion:(FTINWhyGameQuestion *)question
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

- (NSArray *)filterQuestions:(NSArray *)questions
{
	NSMutableArray *filtered = [NSMutableArray array];
	
	for (WhyGameQuestion *questionData in self.questions)
	{
		for (FTINWhyGameQuestion *question in questions)
		{
			if([question.answer isEqualToString:questionData.answer] && [questionData.question isEqualToString:question.question])
			{
				[filtered addObject:question];
			}
		}
	}
	
	return filtered;
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
