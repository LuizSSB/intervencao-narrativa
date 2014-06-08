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
@property (nonatomic, retain) NSSet *subActivitites;
@end

@interface Activity (CoreDataGeneratedAccessors)

- (void)addSubActivititesObject:(SubActivity *)value;
- (void)removeSubActivititesObject:(SubActivity *)value;
- (void)addSubActivitites:(NSSet *)values;
- (void)removeSubActivitites:(NSSet *)values;

@end
