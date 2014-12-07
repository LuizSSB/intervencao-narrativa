//
//  FTINWhyGameSubActivityContent.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINSubActivityContent.h"
#import "FTINWhyGameQuestion.h"

@interface FTINWhyGameSubActivityContent : FTINSubActivityContent

@property (nonatomic) NSArray<FTINWhyGameQuestion> *questions;

@end
