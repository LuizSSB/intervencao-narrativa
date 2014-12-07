//
//  FTINWhyGameQuestion.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol FTINWhyGameQuestion;
@interface FTINWhyGameQuestion : JSONModel

// Serialized
@property (nonatomic) NSString *question;
@property (nonatomic) NSString *answer;

// Non-serialized
@property (nonatomic, readonly) BOOL answered;
@property (nonatomic) NSNumber *chosenNumber;
@property (nonatomic) BOOL chosen;
@property (nonatomic) NSNumber *answerSkillNumber;
@property (nonatomic) FTINAnswerSkill answerSkill;


+ (FTINWhyGameQuestion *)questionWithQuestion:(NSString *)question andAnswer:(NSString *)answer;

@end
