//
//  Activity.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/09.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"

@class Patient, SubActivity;

@interface Activity : BaseEntity

@property (nonatomic, retain) NSNumber * finalized;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Patient *patient;
@property (nonatomic, retain) NSSet *subActivities;
@end

@interface Activity (CoreDataGeneratedAccessors)

- (void)addSubActivitiesObject:(SubActivity *)value;
- (void)removeSubActivitiesObject:(SubActivity *)value;
- (void)addSubActivities:(NSSet *)values;
- (void)removeSubActivities:(NSSet *)values;

@end
