//
//  Macros.h
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/22.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#ifndef FanChorusChantCreator_Macros_h
#define FanChorusChantCreator_Macros_h

// -----------------------------------------------------------------------------
// Tr00 macross

#define AllocateArray(TYPE, UNITS) ((TYPE*)calloc(UNITS, sizeof(TYPE)))

#define DOCUMENTS_DIRECTORY (NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject)

// -----------------------------------------------------------------------------
// Constants

extern NSTimeInterval const FTINDefaultAnimationDuration;
extern CGFloat const FTINBarButtonItemSpacing;
extern NSString const * FTINDefaultCellIdentifier;
extern NSString const * FTINDefaultNamespace;
extern NSString * const FTINDefaultActivityFileName;
extern NSString * const FTINDefaultActivityFileExtension;

// -----------------------------------------------------------------------------
// Blocks types

typedef void (^FTINOperationResult)(id result, NSError *error);

// -----------------------------------------------------------------------------
// Enums

typedef enum : NSUInteger {
    FTINSexMachoMan,
    FTINSexFemmeFatale,
} FTINSex;

typedef enum : NSUInteger {
    FTINActivityTypeDescription,
	FTINActivityTypeArrangement,
	FTINActivityTypeEnvironment
} FTINActivityType;

typedef enum : NSUInteger {
    FTINDescriptiveSkillNoHelp,
    FTINDescriptiveSkillPartialHelp,
    FTINDescriptiveSkillLottaHelp,
	FTINDescriptiveSkillIncompetentFool
} FTINDescriptiveSkill;

typedef enum : NSUInteger {
    FTINNarrativeSkillNoHelp,
    FTINNarrativeSkillPartialHelp,
	FTINNarrativeSkillLottaHelp,
    FTINNarrativeSkillIncompetentFool
} FTINNarrativeSkill;

typedef enum : NSUInteger {
    FTINArrangementSkillNoHelp,
    FTINArrangementSkillHelped
} FTINArrangementSkill;

typedef enum : NSUInteger {
    FTINCoherenceOrganized,
    FTINCoherenceUnorganized
} FTINCoherence;

// -----------------------------------------------------------------------------
// Protocols with same name as Foundation types
// These are to be used with JSONModel DTOs which deal with arrays

@protocol NSString @end
@protocol NSNumber @end

#endif
