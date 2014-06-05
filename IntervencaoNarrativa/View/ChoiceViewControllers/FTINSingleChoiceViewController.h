//
//  FTINSingleChoiceViewController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/04.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINChoiceTableViewController.h"

@interface FTINSingleChoiceViewController : FTINChoiceTableViewController

@property (nonatomic) NSInteger selectedChoiceIndex;
@property (nonatomic) FTINChoice *selectedChoice;
@property (nonatomic) BOOL allowsUnselection;

@end
