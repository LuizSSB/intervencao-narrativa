//
//  WhyGameQuestion.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/07/16.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"

@class WhyGameSubActivity;

@interface WhyGameQuestion : BaseEntity

@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSNumber * answerSkillNumber;
@property (nonatomic, retain) WhyGameSubActivity *parentSubActivity;

@end
