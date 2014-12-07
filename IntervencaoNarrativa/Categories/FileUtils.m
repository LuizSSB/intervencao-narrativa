//
//  FileUtils.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/05/25.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FileUtils.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation FileUtils

+ (NSString *)MIMETypeForFilename:(NSString *)filename defaultMIMEType:(NSString *)defaultType
{
	NSString *result = defaultType;
	NSString *extension = [filename pathExtension];
	CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
	
	if (uti)
	{
		CFStringRef cfMIMEType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType);
		
		if (cfMIMEType)
		{
			result = CFBridgingRelease(cfMIMEType);
		}
		
		CFRelease(uti);
	}
	
	return result;
}

@end
