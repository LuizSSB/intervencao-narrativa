//
//  FTINWhyGameActivityReportFormatter.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/07/19.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINWhyGameActivityReportFormatter.h"
#import "FTINTemplateUtils.h"
#import "FTINWhyGameQuestion.h"

#import "WhyGameSubActivity+Complete.h"

@interface FTINWhyGameActivityReportFormatter ()

@property (nonatomic) NSString *templateResourceName;
@property (nonatomic) NSArray *enumOptions;
@property (nonatomic) NSString *enumKeyPath;

@end

@implementation FTINWhyGameActivityReportFormatter

#pragma mark - Instance methods

- (NSString *)templateResourceName
{
	return @"WhyGameActivityReportTemplate";
}

- (NSString *)enumKeyPath
{
	return NSStringFromSelector(@selector(answerSkill));
}

- (NSArray *)enumOptions
{
	return @[
			 @(FTINAnswerSkillWellStructuredAndCoherent),
			 @(FTINAnswerSkillLittleStructured),
			 @(FTINAnswerSkillIncompetentFool),
			 @(FTINAnswerSkillLittleCoherent)
			 ];
}

- (NSString *)templateKeyPrefix
{
	return @"answerSkill_";
}

- (NSDictionary *)contextForQuestions:(NSSet *)questions
{
	NSMutableArray *questionsContext = [NSMutableArray array];
	
	for (FTINWhyGameQuestion *question in questions)
	{
		NSMutableDictionary *questionContext = [NSMutableDictionary dictionaryWithObject:question.question forKey:@"question"];
		
		for (NSNumber *option in self.enumOptions)
		{
			NSString *value;
			NSString *class;
			
			if(question.answered)
			{
				value = question.answerSkill == option.integerValue ? FTINDefaultCheckedValue : [NSString string];
				class = FTINHTMLClassExecuted;
			}
			else
			{
				value = [NSString string];
				class = FTINHTMLClassSkipped;
			}
			
			NSString *optionKey = [self.templateKeyPrefix stringByAppendingString:option.description];
			
			NSDictionary *subContext = @{
										 FTINTemplateKeyElementClass:class,
										 FTINTemplateKeyElementValue:value
										 };
			[questionContext setObject:subContext forKey:optionKey];
		}
		
		[questionsContext addObject:questionContext];
	}
	
	return @{@"questions": questionsContext};
}

#pragma mark - Activity Report Formatter

- (NSString *)formatActivities:(NSArray *)activities error:(NSError *__autoreleasing *)error
{
	NSDictionary *context = [self contextForQuestions:[activities[0] chosenQuestions]];
	NSURL *templateUrl = [[NSBundle mainBundle] URLForResource:self.templateResourceName withExtension:@"html"];
	
	return [FTINTemplateUtils parseTemplate:templateUrl	withContext:context error:error];
}

@end
