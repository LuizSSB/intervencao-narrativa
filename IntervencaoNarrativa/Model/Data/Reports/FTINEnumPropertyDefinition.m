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
	_templateKeyPrefix = nil;
}

#pragma mark - Instance methods

+ (FTINEnumPropertyDefinition *)definitionWithOptions:(NSArray *)options keyPath:(NSString *)keyPath templateKeyPrefix:(NSString *)templateKeyPrefix
{
	return [[self alloc] initWithOptions:options keyPath:keyPath templateKeyPrefix:templateKeyPrefix];
}

- (instancetype)initWithOptions:(NSArray *)options keyPath:(NSString *)keyPath templateKeyPrefix:(NSString *)templateKeyPrefix
{
    self = [super init];
    if (self) {
        self.enumOptions = options;
		self.enumKeyPath = keyPath;
		self.templateKeyPrefix = templateKeyPrefix;
    }
    return self;
}

- (NSDictionary *)contextForActivities:(NSArray *)activities
{
	NSMutableDictionary *context = [NSMutableDictionary dictionary];
	
	for (NSNumber *option in self.enumOptions)
	{
		NSMutableArray *subContext = [NSMutableArray array];
		
		for (SubActivity *activity in activities)
		{
			NSString *value;
			NSString *class;
			
			if(activity.failed)
			{
				value = [NSString string];
				class = FTINHTMLClassFailed;
			}
			else if(activity.skipped)
			{
				value = [NSString string];
				class = FTINHTMLClassSkipped;
			}
			else
			{
				class = FTINHTMLClassExecuted;
				value = [[activity valueForKeyPath:self.enumKeyPath] integerValue] == option.integerValue ? FTINDefaultCheckedValue : [NSString string];
			}
			
			[subContext addObject:@{
									FTINTemplateKeyElementClass:class,
									FTINTemplateKeyElementValue:value
									}];
		}
		
		[context setObject:subContext forKey:[self.templateKeyPrefix stringByAppendingString:option.description]];
	}
	
	return context;
}

@end