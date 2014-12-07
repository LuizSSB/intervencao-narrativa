//
//  NSObject+Properties.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/16.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "NSObject+Properties.h"
#import <objc/runtime.h>

@implementation NSObject (Properties)

+ (void)simpleMapFrom:(id)source to:(id)destiny
{
	NSAssert([source isKindOfClass:[destiny class]], @"Source and Destiny objects do not match!");
	
	NSDictionary *sourceProperties = [source objectProperties];
	
	for (NSString *propName in sourceProperties.allKeys)
	{
		[destiny setValue:[source valueForKey:propName] forKey:propName];
	}
}

- (NSDictionary *)objectProperties
{
	return [self.class classProperties];
}

+ (NSDictionary *)classProperties
{
	NSMutableDictionary *propertiesDictionary = [NSMutableDictionary dictionary];
	
	unsigned int propertiesCount;
	objc_property_t *properties = class_copyPropertyList(self, &propertiesCount);
	
	for (int i = propertiesCount - 1; i >= 0; --i)
	{
		objc_property_t property = properties[i];
		const char *propertyNameInC = property_getName(property);
		
		if(propertyNameInC)
		{
			NSString *propertyType = getPropertyType(property);
			NSString *propertyName = [NSString stringWithUTF8String:propertyNameInC];
			[propertiesDictionary setObject:propertyType forKey:propertyName];
		}
	}
	
	free(properties);
	
	if(![NSStringFromClass([self superclass]) isEqualToString:NSStringFromClass([NSObject class])])
	{
		[propertiesDictionary addEntriesFromDictionary:[[self superclass] classProperties]];
	}
	
	return propertiesDictionary;
}

// TODO: make this shit here better looking, ugh
// http://stackoverflow.com/questions/754824/get-an-object-properties-list-in-objective-c
static NSString * getPropertyType(objc_property_t property) {
	const char *attributes = property_getAttributes(property);
	
	char buffer[1 + strlen(attributes)];
	strcpy(buffer, attributes);
	
	char *state = buffer;
	char *attribute;
	
	while ((attribute = strsep(&state, ",")))
	{
		if(attribute[0] == 'T')
		{
			if(attribute[1] != '@')
			{
				NSData *typeData = [NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1];
				return [[NSString alloc] initWithData:typeData encoding:NSASCIIStringEncoding];
			}
			else
			{
				if(strlen(attribute) == 2)
				{
					return @"id";
				}
				else
				{
					NSData *typeData = [NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4];
					return [[NSString alloc] initWithData:typeData encoding:NSASCIIStringEncoding];
				}
			}
		}
	}
	
	return @"";
}

@end
