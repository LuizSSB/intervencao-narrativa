//
//  FTINSubActivityContent.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/05.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINSubActivityContent.h"

@implementation FTINSubActivityContent

#pragma mark - Super methods

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
	return [propertyName isEqualToString:NSStringFromSelector(@selector(representativeImageName))];
}

#pragma mark - Instance methods

- (BOOL)validateWithData:(SubActivity *)data error:(NSError *__autoreleasing *)error
{
	return YES;
}

- (NSString *)representativeImageName
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

@end
