//
//  FTINSingleChoiceViewController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/04.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINChoiceViewController.h"

@interface FTINSingleChoiceViewController : FTINChoiceViewController

@property (nonatomic) NSInteger selectedChoiceIndex;
@property (nonatomic) FTINChoice *selectedChoice;

// Luiz: Provavelmente, está bugada, mas no momento não é importante.
@property (nonatomic) BOOL allowsUnselection;

@end
