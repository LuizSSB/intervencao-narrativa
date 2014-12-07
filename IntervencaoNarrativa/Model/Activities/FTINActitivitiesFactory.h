//
//  FTINActitivitiesFactory.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/07.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FTINSubActivityContent, SubActivity;

@interface FTINActitivitiesFactory : NSObject

+ (FTINSubActivityContent *)subActivityContentOfType:(FTINActivityType)type  withContentsofURL:(NSURL *)url error:(NSError **)error;

+ (SubActivity *)subActivityDataOfType:(FTINActivityType)type;

+ (Class)classBasedOnSubActivityType:(FTINActivityType)type withSuffix:(NSString *)suffix;

+ (Class)classBasedOnSubActivityType:(FTINActivityType)type withPrefix:(NSString *)prefix andSuffix:(NSString *)suffix;

+ (Class)classBasedOnSubActivityType:(FTINActivityType)type withNamespace:(NSString *)namespace andPrefix:(NSString *)prefix andSuffix:(NSString *)suffix;

@end
