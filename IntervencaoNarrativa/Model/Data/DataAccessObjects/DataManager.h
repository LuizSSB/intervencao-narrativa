//
//  DataManager.h
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchRequestDescriptor.h"
#import <CoreData/CoreData.h>

@interface DataManager : NSObject

+ (DataManager *)sharedManager;

- (BOOL)existsFetchRequestNamed:(NSString *)requestName;

- (void)registerFetchRequestWithDescriptor:(FetchRequestDescriptor *)descriptor forEntityNamed:(NSString *)entityName;

- (id)newManagedObjectFromEntityNamed:(NSString *)entityName;

- (id)insertObject:(NSManagedObject *)object error:(NSError **)error;

- (id)updateObject:(NSManagedObject *)object error:(NSError **)error;

- (NSArray *)executeFetchRequestNamed:(NSString *)requestName withParams:(NSDictionary *)parameters forEntityNamed:(NSString *)entityName error:(NSError **)error;

- (id)executeUnitaryFetchRequestNamed:(NSString *)requestName withParams:(NSDictionary *)parameters forEntityNamed:(NSString *)entityName error:(NSError **)error;

- (id)objectWithId:(id)objectID fromEntityNamed:(NSString *)entityName error:(NSError **)error;

- (id)deleteObjectWithId:(id)objectID fromEntityNamed:(NSString *)entityName error:(NSError **)error;
@end
