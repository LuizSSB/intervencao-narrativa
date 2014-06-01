//
//  NSString+ReplaceCharactersInSet.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/18.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "NSString+ReplaceStrings.h"

@implementation NSMutableString (ReplaceStrings)

- (NSUInteger)replaceOcurrencesOfString:(NSString *)string withString:(NSString *)replacement
{
	return [self replaceOccurrencesOfString:string withString:replacement options:NSLiteralSearch range:NSMakeRange(0, self.length)];
}

- (NSUInteger)replaceOcurrencesOfStrings:(NSArray *)set withString:(NSString *)replacement
{
	return [self replaceOcurrencesOfStrings:set withString:replacement options:NSLiteralSearch];
}

- (NSUInteger)replaceOcurrencesOfStrings:(NSArray *)set withString:(NSString *)replacement options:(NSStringCompareOptions)options
{
	NSUInteger totalReplacements = 0;
	
	for (NSString *string in set)
	{
		totalReplacements += [self replaceOccurrencesOfString:string withString:replacement options:options range:NSMakeRange(0, self.length)];
	}
	
	return totalReplacements;
}

@end

@implementation NSString (ReplaceCharactersInSet)

- (NSString *)stringByReplacingOcurrencesOfStrings:(NSArray *)set withString:(NSString *)replacement
{
	return [self stringByReplacingOcurrencesOfStrings:set withString:replacement options:NSLiteralSearch];
}

- (NSString *)stringByReplacingOcurrencesOfStrings:(NSArray *)set withString:(NSString *)replacement options:(NSStringCompareOptions)options
{
	NSMutableString *easyWay = [NSMutableString stringWithString:self];
	[easyWay replaceOcurrencesOfStrings:set withString:replacement options:options];
	return easyWay.description;
}
@end
