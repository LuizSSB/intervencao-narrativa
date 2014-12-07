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

NSInteger const FTINSubActivityDifficultyLevelNone = -1;

@implementation FTINSubActivityDetails

#pragma mark - Super methods

- (void)dealloc
{
	self.data = nil;
	self.contentFile = nil;
	self.content = nil;
	self.parentActivity = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.difficultyLevel = FTINSubActivityDifficultyLevelNone;
		self.allowsAutoSkip = NO;
    }
    return self;
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
	return [@[
			  NSStringFromSelector(@selector(data)),
			  NSStringFromSelector(@selector(parentActivity)),
			  NSStringFromSelector(@selector(content)),
			  NSStringFromSelector(@selector(skippable))
			  ] containsObject:propertyName];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
	return [@[
			  NSStringFromSelector(@selector(difficultyLevel)),
			  NSStringFromSelector(@selector(allowsAutoSkip)),
			  ] containsObject:propertyName];
}

#pragma mark - Instance methods

- (BOOL)skippable
{
	return self.difficultyLevel > FTINSubActivityDifficultyLevelNone;
}

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
	return [self.content validateWithData:self.data error:error] && [self.data valid:error];
}

@end
