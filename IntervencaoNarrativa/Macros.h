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
extern NSTimeInterval const FTINDefaultAnimationShortDuration;
extern NSString * const FTINDefaultCellIdentifier;
extern NSString * const FTINDefaultNamespace;
extern NSString * const FTINDefaultActivityFileName;
extern NSString * const FTINDefaultActivityFileExtension;
extern NSString * const FTINDefaultCheckedValue;

extern CGFloat const FTINDefaultChoiceRowHeight;
extern CGFloat const FTINBarButtonItemSpacing;

extern NSString * const FTINHTMLClassSelected;
extern NSString * const FTINHTMLClassSkipped;
extern NSString * const FTINHTMLClassFailed;
extern NSString * const FTINHTMLElementSeparator;

extern CGFloat const FTINActivityScoreMax;
extern CGFloat const FTINActivityScoreSkipped;
extern CGFloat const FTINActivityScoreTrialPenalty;

// -----------------------------------------------------------------------------
// Blocks types

typedef void (^FTINOperationHandler)(id result, NSError *error);

// -----------------------------------------------------------------------------
// Enums

typedef enum : NSUInteger {
    FTINSexMachoMan,
    FTINSexFemmeFatale,
} FTINSex;

typedef enum : NSUInteger {
    FTINActivityTypeDescription,
	FTINActivityTypeArrangement,
	FTINActivityTypeEnvironment,
	FTINActivityTypeWhyGame
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

typedef enum : NSUInteger {
    FTINAnswerSkillWellStructuredAndCoherent,
    FTINAnswerSkillLittleStructured,
    FTINAnswerSkillLittleCoherent,
	FTINAnswerSkillIncompetentFool
} FTINAnswerSkill;

// -----------------------------------------------------------------------------
// Utilitary functions
NSString * FTINActivityTypeTitle(FTINActivityType type);
NSString * FTINActivityTypeInstruction(FTINActivityType type);
NSArray * FTINActivityTypeGetValues();

CGFloat FTINDescriptiveSkillGetScoreMultiplier(FTINDescriptiveSkill skill);
NSArray * FTINDescriptiveSkillGetValues();
NSString *FTINDescriptiveSkillGetTitle(FTINDescriptiveSkill skill);

CGFloat FTINNarrativeSkillGetScoreMultiplier(FTINNarrativeSkill skill);
NSArray * FTINNarrativeSkillGetValues();
NSString *FTINNarrativeSkillGetTitle(FTINNarrativeSkill skill);

CGFloat FTINArrangementSkillGetScoreMultiplier(FTINArrangementSkill skill);
NSArray * FTINArrangementSkillGetValues();
NSString *FTINArrangementSkillGetTitle(FTINArrangementSkill skill);

CGFloat FTINCoherenceGetScoreMultiplier(FTINCoherence skill);
NSArray * FTINCoherenceSkillGetValues();
NSString *FTINCoherenceSkillGetTitle(FTINCoherence skill);

CGFloat FTINAnswerSkillGetScore(FTINAnswerSkill skill);
NSArray * FTINAnswerSkillGetValues();
NSString *FTINAnswerSkillGetTitle(FTINAnswerSkill skill);

// -----------------------------------------------------------------------------
// Protocols with same name as Foundation types
// These are to be used with JSONModel DTOs that deal with arrays

@protocol NSString @end
@protocol NSNumber @end

#endif
