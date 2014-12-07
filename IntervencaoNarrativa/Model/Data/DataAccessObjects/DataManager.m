//
//  DataManager.m
//  FanChorusChantCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "DataManager.h"
#import "NSFileManager+Utils.h"
#import "NSManagedObject+ToDataModel.h"
#import "NSObject+Properties.h"

NSString * const DatabaseName = @"FanCrowdChantCreator";
NSString * const DatabaseFolder = @"Data";

@interface DataManager()
{
	NSManagedObjectContext *_managedObjectContext;
	NSManagedObjectModel *_managedObjectModel;
	NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSManagedObject *)managedObjectWithId:(id)objectID fromEntityNamed:(NSString *)entityName error:(NSError **)error;

@end

@implementation DataManager

+ (void)initialize
{
	[[NSFileManager defaultManager] createDocumentDirectories:@[DatabaseFolder]];
}

#pragma mark - Singleton Pattern

static DataManager *_dataManager;

+ (DataManager *)sharedManager
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_dataManager = [[super alloc] init];
	});
	
	return _dataManager;
}

+ (id)alloc
{
	return [DataManager sharedManager];
}

#pragma mark - Core Data stack (Code adapted from Apple)

- (NSManagedObjectContext *)managedObjectContext
{
	if(!_managedObjectContext)
	{
		NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
		
		if (coordinator)
		{
			_managedObjectContext = [[NSManagedObjectContext alloc] init];
			[_managedObjectContext setPersistentStoreCoordinator:coordinator];
		}
	}
	
	return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
	if (!_managedObjectModel)
	{
		NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
		_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	}
	
	return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
	if (!_persistentStoreCoordinator)
	{
		NSURL *storeURL = [[NSFileManager defaultManager] URLForDocumentFileAt:DatabaseFolder, DatabaseName, nil];
		
		NSError *error = nil;
		_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
		
		if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
		{
			// Nothing special do be done right now. Perhaps in future versions.
			// Must migrate user database to app's new one.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
	
	return _persistentStoreCoordinator;
}

#pragma mark - Utilitary methods

- (BOOL)existsFetchRequestNamed:(NSString *)requestName
{
	return self.managedObjectModel.fetchRequestTemplatesByName[requestName] != nil;
}

- (void)registerFetchRequestWithDescriptor:(FetchRequestDescriptor *)descriptor forEntityNamed:(NSString *)entityName
{
	NSFetchRequest *request = [descriptor trueFetchRequest];
	[request setEntity:self.managedObjectModel.entitiesByName[entityName]];
	[self.managedObjectModel setFetchRequestTemplate:request forName:descriptor.requestName];
}

#pragma mark - CRUD

- (id)newManagedObjectFromEntityNamed:(NSString *)entityName
{
	Class entityClass = NSClassFromString(entityName);
	NSEntityDescription *entityDescription = self.managedObjectModel.entitiesByName[entityName];
	
	id object = [(NSManagedObject *)[entityClass alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
	
	return object;
}

- (id)insertObject:(NSManagedObject *)object error:(NSError *__autoreleasing *)error
{
	[self.managedObjectContext save:error];
	return object;
}

- (id)updateObject:(NSManagedObject *)object error:(NSError *__autoreleasing *)error
{
	[self.managedObjectContext save:error];
	return object;
}

- (NSArray *)executeFetchRequestNamed:(NSString *)requestName withParams:(NSDictionary *)parameters forEntityNamed:(NSString *)entityName error:(NSError *__autoreleasing *)error
{
	NSFetchRequest *request = [self.managedObjectModel fetchRequestFromTemplateWithName:requestName substitutionVariables:parameters];
	
	NSArray *results = [self.managedObjectContext executeFetchRequest:request error:error];
	
	return results;
}

- (id)executeUnitaryFetchRequestNamed:(NSString *)requestName withParams:(NSDictionary *)parameters forEntityNamed:(NSString *)entityName error:(NSError *__autoreleasing *)error
{
	NSArray *results = [self executeFetchRequestNamed:requestName withParams:parameters forEntityNamed:entityName error:error];
	
	if(results.count)
	{
		return results[0];
	}
	else
	{
		return nil;
	}
}

- (id)objectWithId:(id)objectID fromEntityNamed:(NSString *)entityName error:(NSError *__autoreleasing *)error
{
	NSManagedObject *managedObject = [self managedObjectWithId:objectID fromEntityNamed:entityName error:error];
	
	if(managedObject)
	{
		return [managedObject dataModel];
	}
	
	return nil;
}

- (id)deleteObjectWithId:(id)objectID fromEntityNamed:(NSString *)entityName error:(NSError *__autoreleasing *)error
{
	NSManagedObject *object = [self managedObjectWithId:objectID fromEntityNamed:entityName error:error];
	
	if(object)
	{
		id dataModel = [object dataModel];
		
		[self.managedObjectContext deleteObject:object];
		
		if([self.managedObjectContext save:error])
		{
			return dataModel;
		}
	}
	
	return nil;
}

#pragma mark - Private Core Data methods

- (NSManagedObject *)managedObjectWithId:(id)objectID fromEntityNamed:(NSString *)entityName error:(NSError *__autoreleasing *)error
{
	return [self.managedObjectContext existingObjectWithID:objectID error:error];
}

@end
