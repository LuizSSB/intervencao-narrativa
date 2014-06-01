//
//  NSThread+AsyncBlock.h
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/17.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSThread (AsyncBlock)

+ (void)runOnGlobalQueueWithDefaultPriority:(void (^)(void))block;
+ (void)runOnGlobalQueue:(void (^)(void))block priority:(int)priority;
+ (void)runOnMainQueue:(void (^)(void))block;

@end
