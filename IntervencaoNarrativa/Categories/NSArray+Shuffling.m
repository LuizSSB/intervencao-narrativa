//
//  NSArray+Shuffling.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/12.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "NSArray+Shuffling.h"

@implementation NSArray (Shuffling)

- (NSArray *)shuffledArray
{
	NSMutableArray *array = [NSMutableArray arrayWithArray:self];
	[array shuffle];
	return array;
}

@end

@implementation NSMutableArray (Shuffling)

- (void)shuffle
{
    NSUInteger count = self.count;
    for (NSUInteger idx = 0; idx < count; ++idx)
	{
        NSInteger remainingCount = count - idx;
        NSInteger exchangeIndex = idx + arc4random_uniform((u_int32_t)remainingCount);
        [self exchangeObjectAtIndex:idx withObjectAtIndex:exchangeIndex];
    }
}

@end
