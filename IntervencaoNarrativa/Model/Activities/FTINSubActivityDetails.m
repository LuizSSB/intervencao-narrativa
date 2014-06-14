//
//  FTINSubActivity.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/05.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINSubActivityDetails.h"
#import "FTINSubActivityContent.h"
#import "SubActivity+Complete.h"

@implementation FTINSubActivityDetails

#pragma mark - Super methods

- (void)dealloc
{
	self.data = nil;
	self.contentFile = nil;
	self.content = nil;
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

- (void)setContent:(FTINSubActivityContent *)content
{
	_content = content;
	
	if(self.data)
	{
		self.data.title = content.title;
	}
}

- (void)setData:(SubActivity *)data
{
	_data = data;
	
	if (!data.title.length) {
		_data.title = self.content.title;
	}
}

- (BOOL)valid:(NSError *__autoreleasing *)error
{
	return [self.data valid:error] && [self.content validateWithData:self.data error:error];
}

@end
