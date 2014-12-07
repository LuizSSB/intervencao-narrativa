//
//  FTINCoherenceChoiceViewController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINSingleChoiceViewController.h"

@interface FTINCoherenceChoiceViewController : FTINSingleChoiceViewController

@property (nonatomic) FTINCoherence selectedCoherence;
@property (nonatomic) NSString *choiceTextPrefix;

- (id)initWithChoiceTextPrefix:(NSString *)choiceTextPrefix;

@end
