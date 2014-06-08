//
//  NSError+AlertOnError.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/17.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "NSError+AlertOnError.h"

@implementation NSError (AlertOnError)

+ (BOOL)alertOnError:(NSError *)error customMessage:(NSString *)customMessage andDoOnSuccess:(void (^)(void))onSuccess
{
	if(error)
	{
		[[UIApplication sharedApplication].topMostViewController showToastText:customMessage];
		return NO;
	}
	else
	{
		if(onSuccess)
		{
			onSuccess();
		}
		return YES;
	}
}

+ (BOOL)alertOnError:(NSError *)error andDoOnSuccess:(void (^)(void))onSuccess
{
	return [self alertOnError:error customMessage:error.localizedDescription andDoOnSuccess:onSuccess];
}

@end
