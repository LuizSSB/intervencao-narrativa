//
//  UIDevice+SystemVersion.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/11.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "UIDevice+SystemVersion.h"

#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation UIDevice (SystemVersion)

- (BOOL)deviceIsPhone
{
	return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

- (BOOL)deviceIsPhone5
{
	return [self deviceIsPhone] && fabs([UIScreen mainScreen].bounds.size.height - 568.f) < DBL_EPSILON;
}

- (BOOL)deviceIsPad
{
	return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

- (BOOL)systemUsesVersion7Design
{
	return [self systemMainVersionGreaterThanOrEqualTo:7];
}

- (BOOL)systemMainVersionGreaterThan:(int)systemMainVersion
{
	return [self systemVersionGreaterThan:@(systemMainVersion).description];
}

- (BOOL)systemMainVersionGreaterThanOrEqualTo:(int)systemMainVersion
{
	return [self systemVersionGreaterThanOrEqualTo:@(systemMainVersion).description];
}

- (BOOL)systemMainVersionLessThan:(int)systemMainVersion
{
	return [self systemVersionLessThan:@(systemMainVersion).description];
}

- (BOOL)systemMainVersionLessThanOrEqualTo:(int)systemMainVersion
{
	return [self systemVersionLessThanOrEqualTo:@(systemMainVersion).description];
}

- (BOOL)systemMainVersionEqualTo:(int)systemMainVersion
{
	return [self systemVersionEqualTo:@(systemMainVersion).description];
}

- (BOOL)systemVersionGreaterThan:(NSString *)version
{
	return SYSTEM_VERSION_GREATER_THAN(version);
}

- (BOOL)systemVersionGreaterThanOrEqualTo:(NSString *)version
{
	return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version);
}

- (BOOL)systemVersionLessThan:(NSString *)version
{
	return SYSTEM_VERSION_LESS_THAN(version);
}

- (BOOL)systemVersionLessThanOrEqualTo:(NSString *)version
{
	return SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version);
}

- (BOOL)systemVersionEqualTo:(NSString *)version
{
	return SYSTEM_VERSION_EQUAL_TO(version);
}

@end
