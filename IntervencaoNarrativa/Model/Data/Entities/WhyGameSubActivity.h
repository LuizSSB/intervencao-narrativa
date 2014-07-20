//
//  WhyGameSubActivity.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/07/16.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SubActivity.h"

@class WhyGameQuestion;

@interface WhyGameSubActivity : SubActivity

@property (nonatomic, retain) NSSet *questions;
@end

@interface WhyGameSubActivity (CoreDataGeneratedAccessors)

- (void)addQuestionsObject:(WhyGameQuestion *)value;
- (void)removeQuestionsObject:(WhyGameQuestion *)value;
- (void)addQuestions:(NSSet *)values;
- (void)removeQuestions:(NSSet *)values;

@end
