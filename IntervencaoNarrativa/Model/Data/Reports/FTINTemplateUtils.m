//
//  FTINTemplateUtils.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINTemplateUtils.h"
#import "GRMustache.h"

@implementation FTINTemplateUtils

+ (NSMutableDictionary *)checkedEnumListContextFromObjects:(NSArray *)objects withKeyPath:(SEL)keyPath andCheckedValue:(NSString *)value
{
	NSString *keyPathString = NSStringFromSelector(keyPath);
	NSMutableDictionary *context = [NSMutableDictionary dictionary];
	
	NSInteger idx = 0;
	for (NSObject *object in objects)
	{
		NSString *key = [NSString stringWithFormat:@"%ld_%@", (long)idx++, [object valueForKeyPath:keyPathString]];
		[context setObject:value forKey:key];
	}
	
	return context;
}

+ (NSString *)parseTemplate:(NSURL *)templateUrl withContext:(NSDictionary *)context error:(NSError *__autoreleasing *)error
{
	GRMustacheTemplate *template = [GRMustacheTemplate templateFromContentsOfURL:templateUrl error:error];
	
	if(*error)
	{
		return nil;
	}
	
	NSString *parsed = [template renderObject:context error:error];
	return parsed;
}

@end
