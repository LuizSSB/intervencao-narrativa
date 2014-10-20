//
//  FTINEnvironmentElement.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 10/19/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "JSONModel.h"

@protocol FTINEnvironmentElement @end
@interface FTINEnvironmentElement : JSONModel

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *imageName;

@end
