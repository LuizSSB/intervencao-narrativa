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

@end
