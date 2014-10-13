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

- (NSDictionary *)getChosenQuestionsContentsWithSkills
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	
	for (WhyGameQuestion *question in self.questions)
	{
		if(question.chosen)
		{
			FTINWhyGameQuestion *content = [FTINWhyGameQuestion questionWithQuestion:question.question andAnswer:question.answer];
			
			id skill = question.answerSkillNumber ? question.answerSkillNumber : [NSNull null];
			[dictionary setObject:skill forKey:content];
		}
	}
	
	return dictionary;
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

- (void)chooseQuestionsWithContents:(NSArray *)questions
{
	for (FTINWhyGameQuestion *question in questions)
	{
		[self chooseQuestionWithContent:question];
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
	NSSet *chosenQuestions = [self getChosenQuestions];
	
	if(chosenQuestions.count > 0)
	{
		NSInteger questionsAnswered = 0;
		
		for (WhyGameQuestion *question in chosenQuestions)
		{
			if (question.answered)
			{
				++questionsAnswered;
			}
		}
		
		if(questionsAnswered < chosenQuestions.count)
		{
			[NSError ftin_createErrorWithCode:FTINErrorCodePerformanceDataMissing andCustomMessage:@"error_ftin_3001_b".localizedString inReference:error];
		}
		else
		{
			return YES;
		}
	}
	else
	{
		[NSError ftin_createErrorWithCode:FTINErrorCodeNoQuestionChosen inReference:error];
	}
	
	return NO;	
}

@end
