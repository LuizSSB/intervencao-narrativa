//
//  FTINSubActivity.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/05.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

extern NSInteger const FTINSubActivityDifficultyLevelNone;

@class FTINSubActivityContent, SubActivity, FTINActivityDetails;

@protocol FTINSubActivityDetails @end
@interface FTINSubActivityDetails : JSONModel

// Serializable
@property (nonatomic) FTINActivityType type;
@property (nonatomic) NSString *contentFile;
@property (nonatomic) NSInteger difficultyLevel;
@property (nonatomic) BOOL allowsAutoSkip;

// Non-serializable
@property (nonatomic) FTINSubActivityContent *content;
@property (nonatomic) SubActivity *data;
@property (nonatomic, weak) FTINActivityDetails *parentActivity;
@property (nonatomic, readonly) BOOL skippable;

- (BOOL)valid:(NSError **)error;

@end
