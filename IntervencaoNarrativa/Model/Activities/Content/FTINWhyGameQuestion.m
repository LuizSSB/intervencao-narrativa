//
//  FTINWhyGameQuestion.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINWhyGameQuestion.h"

@implementation FTINWhyGameQuestion

#pragma mark - Super methods

- (NSUInteger)hash
{
	NSInteger hash = 0;
	hash += self.question.hash * 13;
	hash += self.answer.hash * 37;
	return hash;
}

- (BOOL)isEqual:(id)object
{
	return object == self
		|| ([object isKindOfClass:[FTINWhyGameQuestion class]]
			&& [[object question] isEqualToString:self.question]
			&& [[object answer] isEqualToString:self.answer]
			);
}

#pragma mark - Instance methods

+ (FTINWhyGameQuestion *)questionWithQuestion:(NSString *)question andAnswer:(NSString *)answer
{
	FTINWhyGameQuestion *content = [[FTINWhyGameQuestion alloc] init];
	content.question = question;
	content.answer = answer;
	
	return content;
}

@end
