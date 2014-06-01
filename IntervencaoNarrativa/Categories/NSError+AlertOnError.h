//
//  NSError+AlertOnError.h
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/17.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (AlertOnError)

+ (BOOL)alertOnError:(NSError *)error andDoOnSuccess:(void (^)(void))onSuccess;

+ (BOOL)alertOnError:(NSError *)error customMessage:(NSString *)customMessage andDoOnSuccess:(void (^)(void))onSuccess;

@end
