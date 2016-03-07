//
//  FTINMountSubActivityContent.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINSubActivityContent.h"

@protocol FTINEnvironmentElement @end
@interface FTINEnvironmentElement : JSONModel

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *imageName;

@end

@interface FTINEnvironmentSubActivityContent : FTINSubActivityContent

// Serialized
@property (nonatomic) NSArray<FTINEnvironmentElement> *correctElements;
@property (nonatomic) NSArray<FTINEnvironmentElement> *incorrectElements;
@property (nonatomic) NSString *background;
@property (nonatomic) NSString *finishedBackground;

// Non serialized
@property (nonatomic, readonly) NSArray *allElements;

- (NSSet *)filterCorrectElements:(NSSet *)elements;

@end