//
//  DataAccessObject.h
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/16.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataAccessObject : NSObject

@property (nonatomic, readonly) NSString *entityName;

- (NSArray *)createOwnFetchRequestsUsingDefaultSortDescriptors:(NSArray *)sorters;

- (id)insert:(id)record error:(NSError **)error;
- (id)update:(id)objectID withData:(id)objectData error:(NSError **)error;
- (NSArray *)selectAllWithError:(NSError **)error;
- (id)select:(id)objectID error:(NSError **)error;
- (id)delete:(id)objectID error:(NSError **)error;

- (NSArray *)executeRequestNamed:(NSString *)request withParams:(NSDictionary *)parameters error:(NSError **)error;
- (id)executeUnitaryRequestNamed:(NSString *)request withParams:(NSDictionary *)parameters error:(NSError **)error;

@end
