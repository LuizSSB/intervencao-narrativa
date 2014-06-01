//
//  NSError+LSSB_CreateError.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/22.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "NSError+LSSB_CreateError.h"

@implementation NSError (ftin_CreateError)

+ (NSError *)ftin_createErrorWithCode:(NSInteger)code
{
	NSString *errorMessage = [@"error_ftin_" stringByAppendingFormat:@"%ld", (long)code].localizedString;
	
	return [self ftin_createErrorWithCode:code andCustomMessage:errorMessage];
}

+(NSError *)ftin_createErrorWithCode:(NSInteger)code andCustomMessage:(NSString *)customMsg
{
	NSError *error = [NSError errorWithDomain:ftin_ErrorDomain code:code userInfo:[NSMutableDictionary dictionaryWithObject:customMsg forKey:NSLocalizedDescriptionKey]];
	return error;
}

@end
