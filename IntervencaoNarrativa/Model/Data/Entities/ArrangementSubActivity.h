//
//  ArrangementSubActivity.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/28.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SubActivity+Complete.h"


@interface ArrangementSubActivity : SubActivity

@property (nonatomic, retain) NSNumber * arrangedCorrectlyNumber;
@property (nonatomic, retain) NSNumber * arrangementSkillNumber;
@property (nonatomic, retain) NSArray * itemsArrangement;
@property (nonatomic, retain) NSNumber * narrativeSkillNumber;

@end
