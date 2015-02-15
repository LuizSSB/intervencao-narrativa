//
//  SubAcitivity+Complete.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/07.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "SubActivity.h"

@class FTINSubActivityContent;

@interface SubActivity (Complete)

- (BOOL)valid:(NSError **)error;

- (void)setupWithContent:(FTINSubActivityContent *)content;

@property (nonatomic) NSInteger difficulty;

@property (nonatomic) FTINActivityStatus status;

@property (nonatomic, readonly) BOOL done;

@property (nonatomic, readonly) BOOL everBeenSkipped;

@property (nonatomic, readonly) BOOL failed;

@property (nonatomic) NSInteger tries;

@property (nonatomic, readonly) NSString *representativeImagePath;

- (CGFloat)calculateScore;
@property (nonatomic, readonly) CGFloat score;
@property (nonatomic, readonly) NSString *formattedScore;

@end
