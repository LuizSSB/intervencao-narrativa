//
//  SubAcitivity+Complete.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/07.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "SubActivity+Complete.h"

@implementation SubActivity (Complete)

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
}

- (NSInteger)tries
{
	return self.triesNumber.integerValue;
}

- (void)setTries:(NSInteger)tries
{
	self.triesNumber = @(tries);
}

@end
