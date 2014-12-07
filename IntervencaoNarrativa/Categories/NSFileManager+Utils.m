//
//  FileUtils.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/11.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "NSFileManager+Utils.h"

NSString * const DirectoryTemp = @"Temp";

@implementation NSFileManager (Utils)

+ (void)initialize
{
	[[NSFileManager defaultManager] createDocumentDirectories:@[DirectoryTemp]];
}

- (NSURL *)URLForDocumentFileAt:(NSString *)path, ...
{
	NSMutableArray *pathComponents = [NSMutableArray arrayWithObjects:DOCUMENTS_DIRECTORY, nil];
	
	va_list providedComponents;
	va_start(providedComponents, path);
	
	for(NSString *component = path; component; component = va_arg(providedComponents, id))
	{
		[pathComponents addObject:component];
	}
	
	va_end(providedComponents);
	
	return [NSURL fileURLWithPathComponents:pathComponents];
}
- (NSURL *)URLForPathComposedOf:(NSString *)path, ...
{
	NSMutableArray *pathComponents = [NSMutableArray arrayWithObjects:DOCUMENTS_DIRECTORY, nil];
	
	va_list providedComponents;
	va_start(providedComponents, path);
	
	for(NSString *component = path; component; component = va_arg(providedComponents, id))
	{
		[pathComponents addObject:component];
	}
	
	va_end(providedComponents);
	
	NSString *poth = [[pathComponents componentsJoinedByString:@"/"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return [NSURL URLWithString:poth];
}

- (NSURL *)URLForTemporaryFileNamed:(NSString *)file withFormat:(NSString *)format
{
	return [self URLForDocumentFileAt:DirectoryTemp, [file stringByAppendingFormat:@".%@", format], nil];
}

- (NSURL *)uniqueURLForTemporaryFileOfFormat:(NSString *)format
{
	NSString *uniqueIdentifier = [[NSUUID UUID] UUIDString];
	return [self URLForTemporaryFileNamed:uniqueIdentifier withFormat:format];
}

- (void)createDocumentDirectories:(NSArray *)directories
{
	NSString *documentsPath = DOCUMENTS_DIRECTORY;
	
	for (NSString *dir in directories)
	{
		if(![self createDirectoryAtPathComponents:documentsPath, dir, nil])
		{
			@throw [[NSException alloc] initWithName:@"FileNotFoundException" reason:@"Could not create provided directories" userInfo:nil];
		}
	}
}

- (BOOL)createDirectoryAtPathComponents:(NSString *)path, ...
{
	NSMutableString *fullPath = [NSMutableString string];
	
	va_list providedComponents;
	va_start(providedComponents, path);
 
	for(NSString *dir = path; dir; dir = va_arg(providedComponents, id))
	{
		[fullPath appendString:@"/"];
		[fullPath appendString:dir];
	}
	
	va_end(providedComponents);
	
	return [self createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:nil];
}
@end
