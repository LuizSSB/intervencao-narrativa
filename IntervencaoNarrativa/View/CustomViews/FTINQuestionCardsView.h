//
//  FTINQuestionCardsView.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FTINWhyGameQuestion;

@interface FTINQuestionCardsView : UICollectionView

@property (nonatomic) BOOL showsAnswers;
@property (nonatomic) UIViewController *parentViewController;
@property (nonatomic) NSArray *questions;

- (BOOL)hasAnswerSkillForQuestion:(FTINWhyGameQuestion *)question;
- (FTINAnswerSkill)answerSkillForQuestion:(FTINWhyGameQuestion *)question;

@end
