//
//  SubActivity.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/07/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"

@class Activity;

@interface SubActivity : BaseEntity

@property (nonatomic, retain) NSNumber * skippedNumber;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * completedNumber;
@property (nonatomic, retain) Activity *parentActivity;

@end
