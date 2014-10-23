//
//  FTINWhyGameQuestion.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINWhyGameQuestion.h"

@interface FTINWhyGameQuestion ()

@end

@implementation FTINWhyGameQuestion

#pragma mark - Super methods

- (NSUInteger)hash
{
	NSInteger hash = 0;
	hash += self.question.hash * 13;
	hash += self.answer.hash * 37;
	hash += self.answerSkillNumber.hash * 23;
	hash += self.chosen;
	return hash;
}

- (BOOL)isEqual:(id)object
{
	return object == self
		|| ([object isKindOfClass:[FTINWhyGameQuestion class]]
			&& [[object question] isEqualToString:self.question]
			&& [[object answer] isEqualToString:self.answer]
			&& [object answerSkill] == self.answerSkill
			&& [object chosen] == self.chosen
			);
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
	return [@[
			  NSStringFromSelector(@selector(answered)),
			  NSStringFromSelector(@selector(chosenNumber)),
			  NSStringFromSelector(@selector(answerSkillNumber)),
			  ] containsObject:propertyName];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
	return [@[
			  NSStringFromSelector(@selector(chosen)),
			  NSStringFromSelector(@selector(answerSkill))
			  ] containsObject:propertyName];
}

#pragma mark - Instance methods

+ (FTINWhyGameQuestion *)questionWithQuestion:(NSString *)question andAnswer:(NSString *)answer
{
	FTINWhyGameQuestion *content = [[FTINWhyGameQuestion alloc] init];
	content.question = question;
	content.answer = answer;
	
	return content;
}

- (BOOL)answered
{
	return self.answerSkillNumber != nil;
}

- (void)setChosenNumber:(NSNumber *)chosenNumber
{
	_chosenNumber = chosenNumber;
	
	if(!chosenNumber.boolValue)
	{
		self.answerSkillNumber = nil;
	}
}

- (BOOL)chosen
{
	return self.chosenNumber.boolValue;
}

- (void)setChosen:(BOOL)chosen
{
	self.chosenNumber = @(chosen);
}

- (void)setAnswerSkillNumber:(NSNumber *)answerSkillNumber
{
	_answerSkillNumber = answerSkillNumber;
	
	if(!answerSkillNumber)
	{
		self.chosen = YES;
	}
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
