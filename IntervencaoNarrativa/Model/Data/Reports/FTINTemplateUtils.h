//
//  FTINTemplateUtils.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTINTemplateUtils : NSObject

+ (NSMutableDictionary *)checkedEnumListContextFromObjects:(NSArray *)objects withKeyPath:(SEL)keyPath andCheckedValue:(NSString *)value;

+ (NSString *)parseTemplate:(NSURL *)templateUrl withContext:(NSDictionary *)context error:(NSError **)error;

@end
