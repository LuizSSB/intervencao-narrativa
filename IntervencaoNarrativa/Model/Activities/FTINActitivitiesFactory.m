//
//  FTINActitivitiesFactory.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/07.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActitivitiesFactory.h"
#import "SubActivity.h"
#import "DCModel.h"
#import "JSONModel.h"

@implementation FTINActitivitiesFactory

+ (FTINSubActivityContent *)subActivityContentOfType:(FTINActivityType)type withContentsofURL:(NSURL *)url error:(NSError *__autoreleasing *)error
{
	NSString *json = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:error];
	
	if(!*error)
	{
		JSONModelError *jsonError = nil;
		FTINSubActivityContent *content = [[[self classBasedOnSubActivityType:type withSuffix:@"SubActivityContent"] alloc] initWithString:json error:&jsonError];
		*error = jsonError;
		
		return content;
	}
	
	return nil;
}

+ (SubActivity *)subActivityDataOfType:(FTINActivityType)type
{
	SubActivity *activity = [[self classBasedOnSubActivityType:type withNamespace:nil andPrefix:nil andSuffix:NSStringFromClass([SubActivity class])] newObject];
	return activity;
}

+ (Class)classBasedOnSubActivityType:(FTINActivityType)type withSuffix:(NSString *)suffix
{
	return [self classBasedOnSubActivityType:type withNamespace:FTINDefaultNamespace.description andPrefix:nil andSuffix:suffix];
}

+ (Class)classBasedOnSubActivityType:(FTINActivityType)type withPrefix:(NSString *)prefix andSuffix:(NSString *)suffix
{
	return [self classBasedOnSubActivityType:type withNamespace:FTINDefaultNamespace.description andPrefix:prefix andSuffix:suffix];
}

+ (Class)classBasedOnSubActivityType:(FTINActivityType)type withNamespace:(NSString *)namespace andPrefix:(NSString *)prefix andSuffix:(NSString *)suffix
{
	NSString *typeName;
	
	switch (type) {
		case FTINActivityTypeDescription:
			typeName = @"Description";
			break;
			
		case FTINActivityTypeArrangement:
			typeName = @"Arrangement";
			break;
			
		case FTINActivityTypeEnvironment:
			typeName = @"Environment";
			break;
	}
	
	if (!namespace)
	{
		namespace = [NSString string];
	}
	
	if (!prefix)
	{
		prefix = [NSString string];
	}
	
	if (!suffix)
	{
		suffix = [NSString string];
	}
	
	NSString *classname = [NSString stringWithFormat:@"%@%@%@%@", namespace, prefix, typeName, suffix];
	Class clazz = NSClassFromString(classname);
	return clazz;
}

@end
