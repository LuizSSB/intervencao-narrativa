//
//  NSError+LSSB_CreateError.h
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/22.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (ftin_CreateError)

+ (NSError *)ftin_createErrorWithCode:(NSInteger)code;
+ (NSError *)ftin_createErrorWithCode:(NSInteger)code andCustomMessage:(NSString *)customMsg;

@end
