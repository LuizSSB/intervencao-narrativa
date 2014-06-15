//
//  FTINAnswerSkillChoiceViewController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINSingleChoiceViewController.h"

@interface FTINAnswerSkillChoiceViewController : FTINSingleChoiceViewController

@property (nonatomic) FTINAnswerSkill selectedSkill;

+ (NSArray *)defaultChoices;

@end
