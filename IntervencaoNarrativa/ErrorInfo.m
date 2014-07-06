//
//  ErrorInfo.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "ErrorInfo.h"

NSString * const FTINErrorDomainDefault = @"ftin_DefaultErrorDomain";
NSString * const FTINErrorDomainActivity = @"ftin_ActivityErrorDomain";
NSString * const FTINErrorDomainSubActivity = @"ftin_SubActivityErrorDomain";

NSRange const FTINErrorRangeDefault = {1, 1000};
NSRange const FTINErrorRangeActivity = {3000, 1000};
NSRange const FTINErrorRangeSubActivity = {6000, 1000};

NSDictionary * getErrorDomainsAndRanges()
{
	static NSDictionary *_domainsAndRanges = nil;
	
	if(!_domainsAndRanges)
	{
		_domainsAndRanges = @{
							  FTINErrorDomainDefault:[NSValue valueWithRange:FTINErrorRangeDefault],
							  FTINErrorDomainActivity:[NSValue valueWithRange:FTINErrorRangeActivity],
							  FTINErrorDomainSubActivity:[NSValue valueWithRange:FTINErrorRangeSubActivity],
							  };
	}
	
	return _domainsAndRanges;
}

NSString * getDomainOfError(FTINErrorCode errorCode)
{
	NSDictionary *domainsAndRanges = getErrorDomainsAndRanges();
	
	for (NSString *key in domainsAndRanges.allKeys)
	{
		if(NSLocationInRange(errorCode, [domainsAndRanges[key] rangeValue]))
		{
			return key;
		}
	}
	
	return FTINErrorDomainDefault;
}