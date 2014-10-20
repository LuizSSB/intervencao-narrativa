//
//  FTINMountSubActivityContent.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINEnvironmentSubActivityContent.h"
#import "EnvironmentSubActivity+Complete.h"

@implementation FTINEnvironmentSubActivityContent

#pragma mark - Super methods

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
	return [@[NSStringFromSelector(@selector(background))] containsObject:propertyName];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
	return [@[NSStringFromSelector(@selector(allObjects))] containsObject:propertyName];
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
				
		for (FTINEnvironmentElement *element in tr00Activity.selectedItems)
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

#pragma mark - Instance methods

- (NSArray *)allElements
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.correctElements];
    [array addObjectsFromArray:self.incorrectElements];
    return array;
}
@end
