//
//  SubAcitivity+Complete.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/07.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "SubActivity+Complete.h"

@implementation SubActivity (Complete)

static NSNumberFormatter *_scoreFormatter;

- (BOOL)valid:(NSError *__autoreleasing *)error
{
	return YES;
}

- (void)setupWithContent:(FTINSubActivityContent *)content
{
}

- (BOOL)skipped
{
	return self.skippedNumber.boolValue;
}

- (void)setSkipped:(BOOL)skipped
{
	self.skippedNumber = @(skipped);
	
	if(skipped)
	{
		self.completed = YES;
		self.failed = NO;
	}
}

- (BOOL)completed
{
	return self.completedNumber.boolValue;
}

- (void)setCompleted:(BOOL)completed
{
	self.completedNumber = @(completed);
	
	if(self.skipped && !completed)
	{
		self.skipped = NO;
	}
	
	if(self.failed && !completed)
	{
		self.failed = NO;
	}
}

- (NSInteger)tries
{
	return self.triesNumber.integerValue;
}

- (void)setTries:(NSInteger)tries
{
	self.triesNumber = @(tries);
}

- (BOOL)failed
{
	return self.failedNumber.boolValue;
}

- (void)setFailed:(BOOL)failed
{
	self.failedNumber = @(failed);
	
	if(failed)
	{
		self.completed = YES;
		self.skipped = NO;
	}
}

- (CGFloat)calculateScore
{
	[self doesNotRecognizeSelector:_cmd];
	return 0;
}

- (CGFloat)score
{
	if(self.failed || !self.completed)
	{
		return 0.f;
	}
	
	if(self.skipped)
	{
		return FTINActivityScoreMax;
	}
	
	return MIN(MAX([self calculateScore], 0), FTINActivityScoreMax);
}

- (NSString *)formattedScore
{
	return @(self.score).scoreValue;
}

@end
