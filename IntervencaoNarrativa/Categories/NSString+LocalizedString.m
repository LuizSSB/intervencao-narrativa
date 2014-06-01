//
//  NSString+LocalizedString.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/11.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "NSString+LocalizedString.h"

@implementation NSString (LocalizedString)

- (NSString *)localizedString
{
	return [self localizedStringInNamespace:[NSString string]];
}

- (NSString *)localizedStringInNamespace:(NSString *)namespace
{
	return NSLocalizedString(self, namespace);
}

- (NSString *)localizedStringWithParam:(id)param
{
	return [NSString stringWithFormat:self.localizedString, param];
}

- (NSString *)localizedStringWithIntParam:(int)param
{
	return [NSString stringWithFormat:self.localizedString, param];
}

@end
