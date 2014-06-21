//
//  ErrorInfo.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * ftin_ErrorDomain;

typedef enum : NSUInteger {
    ftin_InvalidUserSuppliedDataErrorCode = 1,
	ftin_InvalidSubActivityErrorCode = 2,
	ftin_InvalidActivityErrorCode = 3,
	ftin_InvalidDataErrorCode = 4,
	ftin_WrongArrangementOrderErrorCode = 5,
	ftin_EnvironmentLackingErrorCode = 6,
	ftin_EnvironmentOverflowErrorCode = 7,
	ftin_PerformanceDataMissingErrorCode = 8,
	ftin_MailNotPossibleErrorCode = 9
} FTINErrorCodes;