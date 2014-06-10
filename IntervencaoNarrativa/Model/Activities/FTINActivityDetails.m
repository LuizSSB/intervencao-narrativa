//
//  FTINJsonActivity.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/05.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityDetails.h"
#import "Acitivity+Complete.h"

@implementation FTINActivityDetails

#pragma mark - Super methods

- (void)dealloc
{
	self.data = nil;
	self.title = nil;
	self.subActivities = nil;
	self.patient = nil;
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
	return [@[
			  NSStringFromSelector(@selector(data)),
			  NSStringFromSelector(@selector(patient))
			  ] containsObject:propertyName];
}

#pragma mark - Instance methods

- (void)setTitle:(NSString *)title
{
	_title = title;
	
	if(self.data)
	{
		self.data.title = title;
	}
}

- (void)setData:(Activity *)data
{
	_data = data;
	
	if(!data.title.length)
	{
		data.title = self.title;
	}
}

@end
