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

- (NSDictionary *)contextForQuestions:(NSSet *)questions
{
	NSMutableArray *questionsContext = [NSMutableArray array];
	
	for (FTINWhyGameQuestion *question in questions)
	{
		NSMutableDictionary *questionContext = [NSMutableDictionary dictionary];
		[questionsContext addObject:questionContext];
		questionContext[@"question"] = question.question;
		
		NSMutableArray *values = [NSMutableArray array];
		questionContext[@"values"] = values;
		
		for (NSNumber *option in FTINAnswerSkillGetValues())
		{
			NSString *value = [NSString string];
			
			if(question.answered)
			{
				value = [question.answerSkillNumber isEqualToNumber:option] ?  FTINHTMLClassSelected : [NSString string];
			}
			else
			{
				value = FTINHTMLClassSkipped;
			}
			
			[values addObject:@{@"value":value}];
		}
	}
	
	return @{@"questions": questionsContext};
}

#pragma mark - Activity Report Formatter

- (NSString *)formatActivities:(NSArray *)activities error:(NSError *__autoreleasing *)error
{
	NSMutableDictionary *context = [NSMutableDictionary dictionary];
	NSMutableArray *enumValues = [NSMutableArray array];
	context[@"enumValues"] = enumValues;
	
	for(NSNumber *value in FTINAnswerSkillGetValues()) {
		[enumValues addObject:@{
								@"enumValue":[NSString stringWithFormat:@"answerskill_%@", value].localizedString
								}];
	}
	
	[context addEntriesFromDictionary:[self contextForQuestions:[activities[0] chosenQuestions]]];
	
	NSURL *templateUrl = [[NSBundle mainBundle] URLForResource:self.templateResourceName withExtension:@"html"];
	
	return [FTINTemplateUtils parseTemplate:templateUrl	withContext:context error:error];
}

@end
