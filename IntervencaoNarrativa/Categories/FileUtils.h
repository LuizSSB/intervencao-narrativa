//
//  FileUtils.h
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/05/25.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtils : NSObject

+ (NSString *)MIMETypeForFilename:(NSString *)filename defaultMIMEType:(NSString *)defaultType;

@end
