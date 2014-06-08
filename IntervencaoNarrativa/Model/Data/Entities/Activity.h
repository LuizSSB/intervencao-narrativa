//
//  Activity.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/08.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Patient, SubActivity;

@interface Activity : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
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
