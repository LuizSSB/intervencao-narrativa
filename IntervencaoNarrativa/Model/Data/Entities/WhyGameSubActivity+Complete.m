//
//  WhyGameSubActivity+Complete.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "WhyGameSubActivity+Complete.h"

#import "FTINSubActivityContent.h"
#import "FTINWhyGameSubActivityContent.h"
#import "FTINWhyGameQuestion.h"

#import "DCModel.h"


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
	NSSet *chosenQuestions = self.chosenQuestions;
	
	if(chosenQuestions.count > 0)
	{
		for (FTINWhyGameQuestion *question in chosenQuestions)
		{
			if (!question.answered)
			{
				[NSError ftin_createErrorWithCode:FTINErrorCodePerformanceDataMissing andCustomMessage:@"error_ftin_3001_b".localizedString inReference:error];
				return NO;
			}
		}
		
		return YES;
	}
	else
	{
		[NSError ftin_createErrorWithCode:FTINErrorCodeNoQuestionChosen inReference:error];
	}
	
	return NO;	
}

@end
