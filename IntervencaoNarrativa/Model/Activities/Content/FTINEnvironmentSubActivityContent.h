//
//  FTINMountSubActivityContent.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINSubActivityContent.h"

@interface FTINEnvironmentSubActivityContent : FTINSubActivityContent

// Serialized
@property (nonatomic) NSSet<NSString> *correctElements;
@property (nonatomic) NSSet<NSString> *incorrectElements;
@property (nonatomic) NSString *background;

// Non serialized
@property (nonatomic, readonly) NSSet *allElements;

@end
