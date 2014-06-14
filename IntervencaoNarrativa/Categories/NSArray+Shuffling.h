//
//  NSArray+Shuffling.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/12.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Shuffling)

- (NSArray *)shuffledArray;

@end

@interface NSMutableArray (Shuffling)

- (void)shuffle;

@end
