//
//  DataAccessObject.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/16.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "DataAccessObject.h"
#import "DataManager.h"

@interface DataAccessObject ()

@property (nonatomic, readonly) NSString *fetchAllRequestName;

- (void)registerFetchRequests;
- (NSDictionary *)fixPredicateParameters:(NSDictionary *)parameters;

@end

@implementation DataAccessObject

- (instancetype)init
{
	self = [super init];
	if (self) {
		@synchronized(self)
		{
			if(![[DataManager sharedManager] existsFetchRequestNamed:self.fetchAllRequestName])
			{
				[self registerFetchRequests];
			}
		}
	}
	return self;
}

#pragma mark - Abstract methods

- (NSString *)entityName
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (NSArray *)createOwnFetchRequestsUsingDefaultSortDescriptors:(NSArray *)sorters
{
	return nil;
}

#pragma mark - Implemented methods

- (NSString *)fetchAllRequestName
{
	return [@"SelectAll" stringByAppendingString:NSStringFromClass(self.class)];
}

- (void)registerFetchRequests
{
	NSSortDescriptor *sortByCode = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
	NSArray *defaultSorters = @[sortByCode];
	
	FetchRequestDescriptor *requestAllDescriptor = [[FetchRequestDescriptor alloc] init];
	requestAllDescriptor.requestName = self.fetchAllRequestName;
	requestAllDescriptor.sortDescriptors = defaultSorters;
	
	[[DataManager sharedManager] registerFetchRequestWithDescriptor:requestAllDescriptor forEntityNamed:self.entityName];
	NSArray *implementationRequests = [self createOwnFetchRequestsUsingDefaultSortDescriptors:defaultSorters];
	
	if(implementationRequests)
	{
		for (FetchRequestDescriptor *descriptor in implementationRequests)
		{
			[[DataManager sharedManager] registerFetchRequestWithDescriptor:descriptor forEntityNamed:self.entityName];
		}
	}
}

- (id)insert:(id)objectData error:(NSError *__autoreleasing *)error
{
	return [[DataManager sharedManager] insertObjectFromDataModel:objectData forEntityNamed:self.entityName error:error];
}

- (id)update:(id)objectID withData:(id)objectData error:(NSError *__autoreleasing *)error
{
	id virus = [[DataManager sharedManager] updateObjectWithId:objectID withDataModel:objectData forEntityNamed:self.entityName error:error];
	return virus;
}

- (NSArray *)selectAllWithError:(NSError *__autoreleasing *)error
{
	return [self executeRequestNamed:self.fetchAllRequestName withParams:nil error:error];
}

- (id)select:(id)objectID error:(NSError *__autoreleasing *)error
{
	return [[DataManager sharedManager] objectWithId:objectID fromEntityNamed:self.entityName error:error];
}

- (id)delete:(id)objectID error:(NSError *__autoreleasing *)error
{
	return [[DataManager sharedManager] deleteObjectWithId:objectID fromEntityNamed:self.entityName error:error];
}

- (NSDictionary *)fixPredicateParameters:(NSDictionary *)parameters
{
	if(parameters && parameters.count > 0)
	{
		NSMutableDictionary *fixedParameters = [NSMutableDictionary dictionary];
		
		for (NSString *key in parameters.allKeys)
		{
			if([key characterAtIndex:0] == '$')
			{
				fixedParameters[[key substringFromIndex:1]] = parameters[key];
			}
			else
			{
				fixedParameters[key] = parameters[key];
			}
		}
		
		return fixedParameters;
	}
	else
	{
		parameters = @{};
	}
	
	return parameters;
}

#pragma mark - Protected methods

- (NSArray *)executeRequestNamed:(NSString *)request withParams:(NSDictionary *)parameters error:(NSError *__autoreleasing *)error
{
	return [[DataManager sharedManager] executeFetchRequestNamed:request withParams:[self fixPredicateParameters:parameters] forEntityNamed:self.entityName error:error];
}

- (id)executeUnitaryRequestNamed:(NSString *)request withParams:(NSDictionary *)parameters error:(NSError *__autoreleasing *)error
{
	NSArray *results = [self executeRequestNamed:request withParams:parameters error:error];
	
	if(results && results.count > 0)
	{
		return results[0];
	}
	
	return nil;
}

@end
