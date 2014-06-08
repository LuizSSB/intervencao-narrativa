//
//  FTINSubActivity.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/05.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINSubActivityDetails.h"
#import "FTINActivityDetails.h"
#import "FTINActitivitiesFactory.h"
#import "SubActivity+Complete.h"
#import "Acitivity+Complete.h"

@implementation FTINSubActivityDetails

#pragma mark - Super methods

- (void)dealloc
{
	self.contentFile = nil;
	self.content = nil;
	self.data = nil;
	self.parentActivity = nil;
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
	return [@[
			  NSStringFromSelector(@selector(data)),
			  NSStringFromSelector(@selector(parentActivity)),
			  NSStringFromSelector(@selector(content))
			  ] containsObject:propertyName];
}

#pragma mark - Instance methods

- (BOOL)load:(NSError *__autoreleasing *)error
{
	NSString *contentExtension = [[self.contentFile componentsSeparatedByString:@"."] lastObject];
	NSString *contentName = [self.contentFile substringToIndex:[self.contentFile rangeOfString:[@"." stringByAppendingString:contentExtension]].location
							 ];
	NSURL *contentUrl = [[NSBundle mainBundle] URLForResource:contentName withExtension:contentExtension];
	
	if(!contentUrl)
	{
		contentUrl = [NSURL fileURLWithPath:self.contentFile];
	}
	
	self.content = [FTINActitivitiesFactory subActivityContentOfType:self.type withContentsofURL:contentUrl error:error];
	
	if(!*error)
	{
		self.data = [FTINActitivitiesFactory subActivityDataOfType:self.type];
		return YES;
	}
	
	return NO;
}

- (BOOL)save:(NSError *__autoreleasing *)error
{
	if([self.data valid:error])
	{
		self.data.parentActivity = self.parentActivity.data;
		[self.data.parentActivity addSubActivititesObject:self.data];
		return YES;
	}
	
	return NO;
}

@end
