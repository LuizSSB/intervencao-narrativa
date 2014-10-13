//
//  FTINQuestionCardsView.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FTINQuestionCardsView, FTINWhyGameQuestion;

@protocol FTINQuestionCardsViewDelegate <NSObject>

- (void)questionCardsView:(FTINQuestionCardsView *)questionCardsView selectedAnswerSkill:(FTINAnswerSkill)answerSkill forQuestion:(FTINWhyGameQuestion *)question;

@end

@interface FTINQuestionCardsView : UICollectionView

@property (nonatomic, weak) id<FTINQuestionCardsViewDelegate> questionsDelegate;
@property (nonatomic) BOOL showsAnswers;
@property (nonatomic) UIViewController *parentViewController;
@property (nonatomic) NSArray *questions;

- (void)setQuestionsWithAnswerSkills:(NSDictionary *)questionsWithSkills;

@end
