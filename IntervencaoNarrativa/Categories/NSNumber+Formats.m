//
//  NSNumber+Formats.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 12/5/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "NSNumber+Formats.h"

@implementation NSNumber (Formats)

static NSNumberFormatter *_scoreFormatter;

- (NSString *)scoreValue
{
	if(self.floatValue == FTINActivityScoreSkipped)
	{
		return @"---";
	}
	
	if(!_scoreFormatter)
	{
		_scoreFormatter = [[NSNumberFormatter alloc] init];
		_scoreFormatter.maximumFractionDigits = 1;
		_scoreFormatter.minimumFractionDigits = 1;
		_scoreFormatter.minimumIntegerDigits = 1;
		_scoreFormatter.roundingMode = NSNumberFormatterRoundDown;
	}
	
	float floatValue = round(2.0f * self.floatValue) / 2.0f;
	return [_scoreFormatter stringFromNumber:@(floatValue)];
}

@end
