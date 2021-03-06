//
//  ErrorInfo.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const FTINErrorDomainDefault;
extern NSString * const FTINErrorDomainActivity;
extern NSString * const FTINErrorDomainSubActivity;

extern NSRange const FTINErrorRangeDefault;
extern NSRange const FTINErrorRangeActivity;
extern NSRange const FTINErrorRangeSubActivity;

typedef enum : NSUInteger {
    FTINErrorCodeInvalidUserSuppliedData = 1,
	FTINErrorCodeInvalidData = 2,
	FTINErrorCodeMailNotPossible = 3,
	
	FTINErrorCodeInvalidActivity = 3000,
	FTINErrorCodeNoMoreActivitiesLeft = 3007,
	FTINErrorCodePerformanceDataMissing = 3001,
	FTINErrorCodeInvalidSubActivity = 3002,
	FTINErrorCodeNonSkippableSubActivity = 3003,
	FTINErrorCodeNotAllSubActivitiesCompleted = 3004,
	FTINErrorCodeActivityOutOfBounds = 3005,
	FTINErrorCodeSubActivityOutOfBounds = 3005,
	FTINErrorCodeNoQuestionChosen = 3006,
	
	FTINErrorCodeWrongArrangementOrder = 6000,
	FTINErrorCodeEnvironmentLacking = 6001,
	FTINErrorCodeEnvironmentOverflow = 6002,
} FTINErrorCode;

NSString * getDomainOfError(FTINErrorCode errorCode);
NSDictionary * getErrorDomainsAndRanges();