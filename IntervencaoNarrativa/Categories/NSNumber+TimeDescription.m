//
//  NSNumber+TimeDescription.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/31.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "NSNumber+TimeDescription.h"

@implementation NSNumber (TimeDescription)

// TODO: there must be a way to let nsdateformmatter handle this
- (NSString *)timeDescription
{
	NSInteger hours = self.integerValue / 3600;
	NSInteger minutes = (self.integerValue - hours  * 3600) / 60;
	NSInteger seconds = self.integerValue % 60;
	
	NSString *value = [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
	return value;
}

@end
