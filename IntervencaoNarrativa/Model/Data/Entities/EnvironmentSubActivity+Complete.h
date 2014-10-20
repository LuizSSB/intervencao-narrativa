//
//  EnvironmentSubActivity+Complete.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "EnvironmentSubActivity.h"

@interface EnvironmentSubActivity (Complete)

@property (nonatomic) FTINCoherence organizationCoherence;
@property (nonatomic) FTINCoherence narrationCoherence;

@property (nonatomic, readonly) NSSet *selectedItemsNames;

@end
