//
//  FTINEnumPropertyDefinition.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/07/18.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINEnumPropertyDefinition.h"
#import "SubActivity+Complete.h"
#import "FTINActivityReportFormatter.h"

@implementation FTINEnumPropertyDefinition

#pragma mark - Super methods

- (void)dealloc
{
	_enumOptions = nil;
	_enumKeyPath = nil;
	_title = nil;
	_difficultyName = nil;
	_enumValueLocalizedPrefix = nil;
}

- (NSString *)localizeOption:(NSNumber *)option
{
	return [NSString stringWithFormat:@"%@_%@", self.enumValueLocalizedPrefix, option].localizedString;
}

@end