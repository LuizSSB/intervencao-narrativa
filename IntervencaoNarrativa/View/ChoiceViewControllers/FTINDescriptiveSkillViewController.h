//
//  FTINDescriptiveSkillViewController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/04.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINSingleChoiceViewController.h"

@interface FTINDescriptiveSkillViewController : FTINSingleChoiceViewController <FTINChoiceTableViewControllerDelegate>

+ (NSArray *)defaultChoices;

@end
