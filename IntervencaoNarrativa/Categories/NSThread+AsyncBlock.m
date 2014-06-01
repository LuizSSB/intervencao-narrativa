//
//  NSThread+AsyncBlock.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/17.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "NSThread+AsyncBlock.h"

@implementation NSThread (AsyncBlock)

+ (void)runOnGlobalQueueWithDefaultPriority:(void (^)(void))block
{
	[self runOnGlobalQueue:block priority:DISPATCH_QUEUE_PRIORITY_DEFAULT];
}

+ (void)runOnGlobalQueue:(void (^)(void))block priority:(int)priority
{
	dispatch_queue_t globalConcurrentQueue = dispatch_get_global_queue(priority, 0);
	dispatch_async(globalConcurrentQueue, block);
}

+ (void)runOnMainQueue:(void (^)(void))block
{
	dispatch_async(dispatch_get_main_queue(), block);
}

@end
