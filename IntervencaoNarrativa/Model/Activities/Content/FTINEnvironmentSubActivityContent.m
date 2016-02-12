//
//  FTINMountSubActivityContent.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINEnvironmentSubActivityContent.h"
#import "EnvironmentSubActivity+Complete.h"

@implementation FTINEnvironmentElement

@end

@implementation FTINEnvironmentSubActivityContent

#pragma mark - Super methods

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
	return [@[NSStringFromSelector(@selector(allObjects))] containsObject:propertyName] || [super propertyIsIgnored:propertyName];
}

- (BOOL)validateWithData:(SubActivity *)data error:(NSError *__autoreleasing *)error
{
	do
	{
		if(![super validateWithData:data error:error]) break;
		
		if(![data isKindOfClass:[EnvironmentSubActivity class]]) {
			[NSError ftin_createErrorWithCode:FTINErrorCodeInvalidData inReference:error];
			break;
		}
		
		EnvironmentSubActivity *tr00Activity = (id) data;
				
		for (FTINEnvironmentElement *element in tr00Activity.selectedElements)
		{
			if(![self.correctElements containsObject:element])
			{
				[NSError ftin_createErrorWithCode:FTINErrorCodeEnvironmentOverflow inReference:error];
				break;
			}
		}
		
		if(*error) break;
		
		return YES;
	}
	while (NO);
	
	return NO;
}

- (NSString *)representativeImageName
{
	return self.background;
}

#pragma mark - Instance methods

- (NSArray *)allElements
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.correctElements];
    [array addObjectsFromArray:self.incorrectElements];
    return array;
}

- (NSSet *)filterCorrectElements:(NSSet *)elements
{
	NSMutableSet *corrects = [NSMutableSet set];
	
	[elements enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
		if([self.correctElements containsObject:obj])
		{
			[corrects addObject:obj];
		}
	}];
	
	return corrects;
}

@end
