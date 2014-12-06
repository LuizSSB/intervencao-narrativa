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
	return @"DefaultEnumActivityReportTemplate";
}

- (void)customizeContext:(NSMutableDictionary *)context forActivities:(NSArray *)activities
{
}

- (NSArray *)enumPropertiesDefinitions
{
	NSLog(@"Nenhuma definição de propriedade de enum configurada");
	return @[];
}

#pragma mark - Activity Report Formatter

- (NSString *)formatActivities:(NSArray *)activities error:(NSError *__autoreleasing *)error
{
	NSMutableDictionary *context = [NSMutableDictionary dictionary];
	NSMutableArray *propsContexts = [NSMutableArray array];
	context[@"enumProp"] = propsContexts;
	
	for (FTINEnumPropertyDefinition *prop in self.enumPropertiesDefinitions) {
		NSMutableDictionary *propContext = [NSMutableDictionary dictionary];
		[propsContexts addObject:propContext];
		propContext[@"enumTitle"] = prop.title;
		
		if(prop.difficultyName.length)
		{
			propContext[@"difficultyName"] = prop.difficultyName;
		}
		
		// Adiciona referências as opções do enum
		NSMutableArray *enumValues = [NSMutableArray array];
		propContext[@"enumValues"] = enumValues;
		
		for (NSNumber *option in prop.enumOptions)
		{
			[enumValues addObject:@{@"enumValue":[prop localizeOption:option]}];
		}
		
		// Adiciona referências as atividades
		NSMutableArray *activitiesContexts = [NSMutableArray array];
		propContext[@"activities"] = activitiesContexts;
		
		[activities enumerateObjectsUsingBlock:^(SubActivity *obj, NSUInteger idx, BOOL *stop) {
			NSMutableDictionary *activityContext = [NSMutableDictionary dictionary];
			[activitiesContexts addObject:activityContext];
			activityContext[@"id"] = @(idx + 1);
			
			if(prop.difficultyName.length)
			{
				activityContext[@"difficulty"] = obj.difficultyNumber;
			}
			
			// Adiciona o X na opção selecionada do enum
			NSMutableArray *values = [NSMutableArray array];
			activityContext[@"values"] = values;
			
			for (NSNumber *option in prop.enumOptions)
			{
				NSString *value;
				
				if([[obj valueForKeyPath:prop.enumKeyPath] isEqual:option])
				{
					value = FTINHTMLClassSelected;
				}
				else if(obj.skipped)
				{
					value = FTINHTMLClassSkipped;
				}
				else if(obj.failed)
				{
					value = FTINHTMLClassFailed;
				}
				else
				{
					value = [NSString string];
				}
				
				[values addObject:@{@"value": value}];
			}
			
		}];
	}

	[self customizeContext:context forActivities:activities];
	
	NSURL *templateUrl = [[NSBundle mainBundle] URLForResource:self.templateResourceName withExtension:@"html"];
	
	return [FTINTemplateUtils parseTemplate:templateUrl	withContext:context error:error];
}

@end
