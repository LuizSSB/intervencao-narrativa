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
	if([super validateWithData:data error:error])
	{
		do
		{
			if(![data isKindOfClass:[EnvironmentSubActivity class]]) {
				*error = [NSError ftin_createErrorWithCode:ftin_InvalidDataErrorCode];
				break;
			}
			
			EnvironmentSubActivity *tr00Activity = (id) data;
			
			if(tr00Activity.selectedItems.count != self.correctElements.count)
			{
				*error = [NSError ftin_createErrorWithCode:ftin_EnvironmentLackingErrorCode];
				break;
			}
			
			for (NSString *element in tr00Activity.selectedItems)
			{
				if(![self.correctElements containsObject:element])
				{
					*error = [NSError ftin_createErrorWithCode:ftin_EnvironmentOverflowErrorCode];
					break;
				}
			}
			
			if(*error) break;
			
			return YES;
		}
		while (NO);
	}
	
	return NO;
}

#pragma mark - Instance methods

- (NSSet *)allElements
{
	NSMutableSet *objects = [NSMutableSet setWithSet:self.correctElements];
	return [objects setByAddingObjectsFromSet:self.incorrectElements];
}

@end
