//
//  FTINSubActivityContent.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/05.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "JSONModel.h"

@class SubActivity;

@interface FTINSubActivityContent : JSONModel

@property (nonatomic) NSString *title;

- (BOOL)validateWithData:(SubActivity *)data error:(NSError **)error;

@end
