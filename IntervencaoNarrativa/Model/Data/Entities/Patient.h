//
//  Patient.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/09.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"

@class Activity;

@interface Patient : BaseEntity

@property (nonatomic, retain) NSDate * birthdate;
@property (nonatomic, retain) NSString * examiner;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * sexInteger;
@property (nonatomic, retain) NSSet *activities;
@end

@interface Patient (CoreDataGeneratedAccessors)

- (void)addActivitiesObject:(Activity *)value;
- (void)removeActivitiesObject:(Activity *)value;
- (void)addActivities:(NSSet *)values;
- (void)removeActivities:(NSSet *)values;

@end
