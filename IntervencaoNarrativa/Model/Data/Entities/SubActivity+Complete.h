//
//  SubAcitivity+Complete.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/07.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "SubActivity.h"

@interface SubActivity (Complete)

- (BOOL)valid:(NSError **)error;

@property (nonatomic) BOOL skipped;

@property (nonatomic) BOOL completed;

@property (nonatomic) NSInteger tries;

@end
