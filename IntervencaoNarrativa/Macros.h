//
//  Macros.h
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/22.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#ifndef FanChorusChantCreator_Macros_h
#define FanChorusChantCreator_Macros_h

#define AllocateArray(TYPE, UNITS) ((TYPE*)calloc(UNITS, sizeof(TYPE)))
#define DOCUMENTS_DIRECTORY (NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject)

extern CGSize const AdBannerStandardSize;
extern NSTimeInterval const FTINDefaultAnimationDuration;
extern NSString const * FTINDefaultCellIdentifier;

typedef void (^FTINOperationResult)(id result, NSError *error);

typedef enum : NSUInteger {
    FTINSexMachoMan,
    FTINSexFemmeFatale,
} FTINSex;

#endif
