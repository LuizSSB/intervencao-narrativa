//
//  FTINEnumActivityReportFormatter.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINEnumActivityReportFormatter.h"
#import "FTINTemplateUtils.h"
#import "FTINEnumPropertyDefinition.h"
#import "SubActivity+Complete.h"

@interface FTINEnumActivityReportFormatter ()

@end

@implementation FTINEnumActivityReportFormatter

#pragma mark - Abstract and Hook methods

- (NSString *)templateResourceName
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (void)customizeContext:(NSMutableDictionary *)context forActivities:(NSArray *)activities
{
}

- (NSArray *)enumPropertiesDefinitions
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

#pragma mark - Activity Report Formatter

- (NSString *)formatActivities:(NSArray *)activities error:(NSError *__autoreleasing *)error
{
	NSMutableDictionary *context = [NSMutableDictionary dictionary];
	
	for(FTINEnumPropertyDefinition *definition in self.enumPropertiesDefinitions)
	{
		[context addEntriesFromDictionary:[definition contextForActivities:activities]];
	}
	
	[self customizeContext:context forActivities:activities];
	
	NSURL *templateUrl = [[NSBundle mainBundle] URLForResource:self.templateResourceName withExtension:@"html"];
	
	return [FTINTemplateUtils parseTemplate:templateUrl	withContext:context error:error];
}

@end
