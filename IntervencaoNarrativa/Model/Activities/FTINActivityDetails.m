//
//  FTINJsonActivity.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/05.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityDetails.h"
#import "FTINSubActivityDetails.h"

@implementation FTINActivityDetails

#pragma mark - Super methods

- (void)dealloc
{
	self.title = nil;
	self.subActivities = nil;
	self.data = nil;
	self.patient = nil;
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
	return [@[
			  NSStringFromSelector(@selector(data)),
			  NSStringFromSelector(@selector(patient))
			  ] containsObject:propertyName];
}

@end
