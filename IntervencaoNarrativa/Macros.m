//
//  Macros.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/22.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

NSTimeInterval const FTINDefaultAnimationDuration = .3;
NSTimeInterval const FTINDefaultAnimationShortDuration = .15;
NSString * const FTINDefaultCellIdentifier = @"Cell";
NSString * const FTINDefaultNamespace = @"FTIN";
NSString * const FTINDefaultCheckedValue = @"X";

#warning FIXME voltar para mainActivity antes de distribuir
//NSString * const FTINDefaultActivityFileName = @"mainActivity";
NSString * const FTINDefaultActivityFileName = @"debugActivity";
NSString * const FTINDefaultActivityFileExtension = @"json";

CGFloat const FTINDefaultChoiceRowHeight = 44.f;
CGFloat const FTINBarButtonItemSpacing = 20.f;

NSString * const FTINHTMLClassSelected = @"selected";
NSString * const FTINHTMLClassSkipped = @"skipped";
NSString * const FTINHTMLClassFailed = @"failed";
NSString * const FTINHTMLElementSeparator = @", "; // <br /> is escaped before put in use

CGFloat const FTINActivityScoreMax = 10.f;
CGFloat const FTINActivityScoreSkipped = MAXFLOAT;
CGFloat const FTINActivityScoreTrialPenalty = 3.f;

NSString * FTINActivityTypeTitle(FTINActivityType type)
{
	return [@"activity_" stringByAppendingFormat:@"%ld", (long) type].localizedString;
}

NSString * FTINActivityTypeInstruction(FTINActivityType type)
{
	return [@"activity_description_" stringByAppendingFormat:@"%ld", (long) type].localizedString;
}

NSArray * FTINActivityTypeGetValues()
{
	return @[
			 @(FTINActivityTypeDescription),
			 @(FTINActivityTypeArrangement),
			 @(FTINActivityTypeEnvironment),
			 @(FTINActivityTypeWhyGame)
			 ];
}

CGFloat FTINDescriptiveSkillGetScoreMultiplier(FTINDescriptiveSkill skill)
{
	switch (skill) {
		case FTINDescriptiveSkillNoHelp:
			return 1.f;
		case FTINDescriptiveSkillPartialHelp:
			return .75f;
		case FTINDescriptiveSkillLottaHelp:
			return .5f;
		case FTINDescriptiveSkillIncompetentFool:
			return .25f;
		default:
			return 0.f;
	}
}

CGFloat FTINNarrativeSkillGetScoreMultiplier(FTINNarrativeSkill skill)
{
	switch (skill) {
		case FTINNarrativeSkillNoHelp:
			return 1.f;
		case FTINNarrativeSkillPartialHelp:
			return .75f;
		case FTINNarrativeSkillLottaHelp:
			return .5f;
		case FTINNarrativeSkillIncompetentFool:
			return .25f;
		default:
			return 0.f;
	}
}

CGFloat FTINArrangementSkillGetScoreMultiplier(FTINArrangementSkill skill)
{
	switch (skill) {
		case FTINArrangementSkillNoHelp:
			return 1.f;
		case FTINArrangementSkillHelped:
			return .5f;
		default:
			return 0;
	}
}

CGFloat FTINCoherenceGetScoreMultiplier(FTINCoherence skill)
{
	switch (skill) {
		case FTINCoherenceOrganized:
			return 1.f;
		case FTINCoherenceUnorganized:
			return .5f;
		default:
			return 0.f;
	}
}

CGFloat FTINAnswerSkillGetScore(FTINAnswerSkill skill)
{
	switch (skill)
	{
		case FTINAnswerSkillWellStructuredAndCoherent:
			return FTINActivityScoreMax;
		case FTINAnswerSkillLittleStructured:
			return FTINActivityScoreMax * 2.f / 3.f;
		case FTINAnswerSkillLittleCoherent:
			return FTINActivityScoreMax / 3.f;
		default:
			return 0.f;
	}
}

NSArray * FTINDescriptiveSkillGetValues()
{
	return @[
			 @(FTINDescriptiveSkillNoHelp),
			 @(FTINDescriptiveSkillPartialHelp),
			 @(FTINDescriptiveSkillLottaHelp),
			 @(FTINDescriptiveSkillIncompetentFool)
			 ];
}

NSArray * FTINNarrativeSkillGetValues()
{
	return @[
			 @(FTINNarrativeSkillNoHelp),
			 @(FTINNarrativeSkillPartialHelp),
			 @(FTINNarrativeSkillLottaHelp),
			 @(FTINNarrativeSkillIncompetentFool)
			 ];
}

NSArray * FTINArrangementSkillGetValues()
{
	return @[
			 @(FTINArrangementSkillNoHelp),
			 @(FTINArrangementSkillHelped)
			 ];
}

NSArray * FTINCoherenceSkillGetValues()
{
	return @[
			 @(FTINCoherenceOrganized),
			 @(FTINCoherenceUnorganized)
			 ];
}

NSArray * FTINAnswerSkillGetValues()
{
	return @[
			 @(FTINAnswerSkillWellStructuredAndCoherent),
			 @(FTINAnswerSkillLittleStructured),
			 @(FTINAnswerSkillLittleCoherent),
			 @(FTINAnswerSkillIncompetentFool)
			 ];
}

NSString *FTINDescriptiveSkillGetTitle(FTINDescriptiveSkill skill)
{
	return [NSString stringWithFormat:@"descriptionskill_%lu", (unsigned long) skill].localizedString;
}

NSString *FTINNarrativeSkillGetTitle(FTINNarrativeSkill skill)
{
	return [NSString stringWithFormat:@"narrationskill_%lu", (unsigned long) skill].localizedString;
}

NSString *FTINArrangementSkillGetTitle(FTINArrangementSkill skill)
{
	return [NSString stringWithFormat:@"arrangeskill_%lu", (unsigned long) skill].localizedString;
}

NSString *FTINCoherenceSkillGetTitle(FTINCoherence skill)
{
	return [NSString stringWithFormat:@"coherenceskill_%lu", (unsigned long) skill].localizedString;
}

NSString *FTINAnswerSkillGetTitle(FTINAnswerSkill skill)
{
	return [NSString stringWithFormat:@"answerskill_%lu", (unsigned long) skill].localizedString;
}
