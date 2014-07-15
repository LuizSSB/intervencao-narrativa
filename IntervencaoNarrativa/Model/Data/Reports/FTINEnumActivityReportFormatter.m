//
//  FTINEnumActivityReportFormatter.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINEnumActivityReportFormatter.h"
#import "FTINTemplateUtils.h"
#import "SubActivity+Complete.h"

NSString * const FTINHTMLClassExecuted = @"executed";
NSString * const FTINHTMLClassSkipped = @"skipped";
NSString * const FTINTemplateKeyElementClass = @"class";
NSString * const FTINTemplateKeyElementValue = @"value";
NSString * const FTINTemplateKeyElementOptionFormat = @"option_%@";

@interface FTINEnumActivityReportFormatter ()

- (NSMutableDictionary *)contextForActivities:(NSArray *)activities;

@end

@implementation FTINEnumActivityReportFormatter

#pragma mark - Instance methods

- (NSMutableDictionary *)contextForActivities:(NSArray *)activities
{
	NSString *keyPath = NSStringFromSelector(self.enumKeyPath);
	NSMutableDictionary *context = [NSMutableDictionary dictionary];
	
	for (NSNumber *option in self.enumOptions)
	{
		NSMutableArray *subContext = [NSMutableArray array];
		
		for (SubActivity *activity in activities)
		{
			NSString *value;
			NSString *class;
			
			if(activity.skipped)
			{
				value = [NSString string];
				class = FTINHTMLClassSkipped;
			}
			else
			{
				class = FTINHTMLClassExecuted;
				value =  [[activity valueForKeyPath:keyPath] integerValue] == option.integerValue ? FTINDefaultCheckedValue : [NSString string];
			}
			
			[subContext addObject:@{
									FTINTemplateKeyElementClass:class,
									FTINTemplateKeyElementValue:value
									}];
		}
		
		[context setObject:subContext forKey:[NSString stringWithFormat:FTINTemplateKeyElementOptionFormat, option]];
	}
	
	return context;
}

#pragma mark - Abstract and Hook methods

- (NSString *)templateResourceName
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (SEL)enumKeyPath
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (NSArray *)enumOptions
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (void)customizeContext:(NSMutableDictionary *)context
{
}

#pragma mark - Activity Report Formatter

- (NSString *)formatActivities:(NSArray *)activities error:(NSError *__autoreleasing *)error
{
	NSMutableDictionary *context = [self contextForActivities:activities];
	
	[self customizeContext:context];
	
	NSURL *templateUrl = [[NSBundle mainBundle] URLForResource:self.templateResourceName withExtension:@"html"];
	
	return [FTINTemplateUtils parseTemplate:templateUrl	withContext:context error:error];
}


@end
