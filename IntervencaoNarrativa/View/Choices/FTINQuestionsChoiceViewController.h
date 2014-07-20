//
//  FTINQuestionsChoiceViewController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/07/17.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINChoiceViewController.h"

@class FTINQuestionsChoiceViewController;

@protocol FTINQuestionsChoiceViewControllerDelegate <NSObject>

- (void)questionsChoiceViewController:(FTINQuestionsChoiceViewController *)viewController choseQuestions:(NSArray *)questions;

@end

@interface FTINQuestionsChoiceViewController : FTINChoiceViewController

@property (nonatomic, weak) id<FTINQuestionsChoiceViewControllerDelegate> questionsDelegate;

- (NSArray *)getSelectedQuestions;

@end
