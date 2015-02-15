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
@property (nonatomic) NSString *representativeImageName;

- (BOOL)validateWithData:(SubActivity *)data error:(NSError **)error;

@end
