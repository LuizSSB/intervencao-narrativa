//
//  NSString+ReplaceCharactersInSet.h
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/18.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (ReplaceStrings)

- (NSUInteger)replaceOcurrencesOfString:(NSString *)string withString:(NSString *)replacement;

- (NSUInteger)replaceOcurrencesOfStrings:(NSArray *)set withString:(NSString *)replacement options:(NSStringCompareOptions)options;
- (NSUInteger)replaceOcurrencesOfStrings:(NSArray *)set withString:(NSString *)replacement;

@end

@interface NSString (ReplaceCharactersInSet)

- (NSString *)stringByReplacingOcurrencesOfStrings:(NSArray *)set withString:(NSString *)replacement options:(NSStringCompareOptions)options;
- (NSString *)stringByReplacingOcurrencesOfStrings:(NSArray *)set withString:(NSString *)replacement;

@end
