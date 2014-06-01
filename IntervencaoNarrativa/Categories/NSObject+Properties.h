//
//  NSObject+Properties.h
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/16.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Properties)

- (NSDictionary *)objectProperties;
+ (NSDictionary *)classProperties;

+ (void)simpleMapFrom:(id)source to:(id)destiny;

@end
