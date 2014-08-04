//
//  WhyGameSubActivity+Complete.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "WhyGameSubActivity.h"

@class FTINWhyGameQuestion;

@interface WhyGameSubActivity (Complete)

- (NSSet *)getChosenQuestions;

- (void)chooseQuestionWithContent:(FTINWhyGameQuestion *)question;
- (void)unchooseAllQuestions;

- (void)setSkill:(FTINAnswerSkill)skill forQuestionWithContent:(FTINWhyGameQuestion *)question;


@end
