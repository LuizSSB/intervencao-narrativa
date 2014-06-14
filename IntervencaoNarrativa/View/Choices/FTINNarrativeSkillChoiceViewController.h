//
//  FTINNarrativeSkillChoiceViewController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/10.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINSingleChoiceViewController.h"

@interface FTINNarrativeSkillChoiceViewController : FTINSingleChoiceViewController

@property (nonatomic) FTINNarrativeSkill selectedSkill;

+ (NSArray *)defaultChoices;

@end
