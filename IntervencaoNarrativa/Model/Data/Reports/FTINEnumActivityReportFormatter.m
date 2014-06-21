//
//  FTINEnumActivityReportFormatter.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINEnumActivityReportFormatter.h"
#import "FTINTemplateUtils.h"

@implementation FTINEnumActivityReportFormatter

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

- (void)customizeContext:(NSMutableDictionary *)context
{
}

#pragma mark - Activity Report Formatter

- (NSString *)formatActivities:(NSArray *)activities error:(NSError *__autoreleasing *)error
{
	NSMutableDictionary *context = [FTINTemplateUtils checkedEnumListContextFromObjects:activities withKeyPath:self.enumKeyPath andCheckedValue:FTINDefaultCheckedValue];
	
	[self customizeContext:context];
	
	NSURL *templateUrl = [[NSBundle mainBundle] URLForResource:self.templateResourceName withExtension:@"html"];
	
	return [FTINTemplateUtils parseTemplate:templateUrl	withContext:context error:error];
}


@end
