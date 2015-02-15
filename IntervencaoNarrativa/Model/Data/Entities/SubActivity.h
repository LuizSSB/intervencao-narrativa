//
//  SubActivity.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/07/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"

@class Activity;

@interface SubActivity : BaseEntity

@property (nonatomic, retain) NSNumber * statusNumber;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * triesNumber;
@property (nonatomic, retain) NSNumber * difficultyNumber;
@property (nonatomic, retain) Activity *parentActivity;
@property (nonatomic, retain) NSString * representativeImageName;

@end
