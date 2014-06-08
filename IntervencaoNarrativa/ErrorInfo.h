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
    ftin_InvalidDataErrorCode = 1,
	ftin_InvalidSubActivityErrorCode = 2,
	ftin_InvalidActivityErrorCode = 3
} FTINErrorCodes;