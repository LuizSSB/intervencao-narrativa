//
//  FTINEnumPropertyDefinition.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/07/18.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTINEnumPropertyDefinition : NSObject

@property (nonatomic) NSArray *enumOptions;
@property (nonatomic) NSString *enumKeyPath;
@property (nonatomic) NSString *templateKeyPrefix;

+ (FTINEnumPropertyDefinition *)definitionWithOptions:(NSArray *)options keyPath:(NSString *)keyPath templateKeyPrefix:(NSString *)templateKeyPrefix;

- (id)initWithOptions:(NSArray *)options keyPath:(NSString *)keyPath templateKeyPrefix:(NSString *)templateKeyPrefix;

- (NSDictionary *)contextForActivities:(NSArray *)activities;

@end
