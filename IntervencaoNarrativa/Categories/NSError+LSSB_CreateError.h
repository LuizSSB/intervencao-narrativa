//
//  NSError+LSSB_CreateError.h
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/22.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (ftin_CreateError)

+ (BOOL)ftin_createErrorWithCode:(NSInteger)code inReference:(NSError **)error;
+ (BOOL)ftin_createErrorWithCode:(NSInteger)code andCustomMessage:(NSString *)customMsg inReference:(NSError **)error;

+ (NSError *)ftin_createErrorWithCode:(NSInteger)code;
+ (NSError *)ftin_createErrorWithCode:(NSInteger)code andCustomMessage:(NSString *)customMsg;

@end
