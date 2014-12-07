//
//  FileUtils.h
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/11.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Utils)

- (NSURL *)URLForDocumentFileAt:(NSString *)path, ... NS_REQUIRES_NIL_TERMINATION;

- (NSURL *)URLForPathComposedOf:(NSString *)path, ... NS_REQUIRES_NIL_TERMINATION;

- (NSURL *)URLForTemporaryFileNamed:(NSString *)file withFormat:(NSString *)format;

- (NSURL *)uniqueURLForTemporaryFileOfFormat:(NSString *)format;

- (void)createDocumentDirectories:(NSArray *)directories;

- (BOOL)createDirectoryAtPathComponents:(NSString *)path, ... NS_REQUIRES_NIL_TERMINATION;

@end
