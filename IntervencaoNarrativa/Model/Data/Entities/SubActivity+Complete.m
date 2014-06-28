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

- (BOOL)skipped
{
	return self.skippedNumber.boolValue;
}

- (void)setSkipped:(BOOL)skipped
{
	self.skippedNumber = @(skipped);
}

@end
