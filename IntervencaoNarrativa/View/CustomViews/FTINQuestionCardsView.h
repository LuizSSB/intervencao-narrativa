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

- (void)questionCardsView:(FTINQuestionCardsView *)questionCardsView selectedQuestion:(FTINWhyGameQuestion *)question;

@end

@interface FTINQuestionCardsView : UICollectionView

@property (nonatomic, weak) id<FTINQuestionCardsViewDelegate> questionsDelegate;
@property (nonatomic) NSArray *questions;

- (void)unselectQuestion:(FTINWhyGameQuestion *)question;

@end
