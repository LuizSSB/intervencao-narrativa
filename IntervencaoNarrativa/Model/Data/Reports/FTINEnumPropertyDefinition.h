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
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *difficultyName;
@property (nonatomic) NSString *enumValueLocalizedPrefix;

- (NSString *)localizeOption:(NSNumber *)option;

@end
