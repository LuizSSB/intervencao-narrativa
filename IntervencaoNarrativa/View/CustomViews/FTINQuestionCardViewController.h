//
//  FTINQuestionCardViewController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FTINQuestionCardViewController, FTINWhyGameQuestion;

@protocol FTINQuestionCardViewControllerDelegate <NSObject>

- (void)questionCardViewControllerCanceled:(FTINQuestionCardViewController *)viewController;

- (void)questionCardViewController:(FTINQuestionCardViewController *)viewController withAnswerSkill:(FTINAnswerSkill)skill;

@end

@interface FTINQuestionCardViewController : UIViewController

@property (nonatomic, weak) id<FTINQuestionCardViewControllerDelegate> delegate;
@property (nonatomic) BOOL showsAnswerVisiblityControl;
@property (nonatomic) FTINWhyGameQuestion *question;

@property (nonatomic, readonly) BOOL answered;
@property (nonatomic) FTINAnswerSkill answerSkill;

- (id)initWithDelegate:(id<FTINQuestionCardViewControllerDelegate>)delegate;

- (void)removeAnswerSkill;

@end
