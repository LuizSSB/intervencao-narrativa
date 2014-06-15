//
//  FTINAnswerSkillChoiceViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINAnswerSkillChoiceViewController.h"
#import "FTINChoice.h"

@interface FTINAnswerSkillChoiceViewController ()

@end

@implementation FTINAnswerSkillChoiceViewController

#pragma mark - Super methods

- (instancetype)init
{
    self = [super initWithChoices:[FTINAnswerSkillChoiceViewController defaultChoices]];
    if (self) {
    }
    return self;
}

#pragma mark - Instance methods

- (FTINAnswerSkill)selectedSkill
{
	return (FTINAnswerSkill) self.selectedChoiceIndex;
}

- (void)setSelectedSkill:(FTINAnswerSkill)selectedSkill
{
	self.selectedChoiceIndex = selectedSkill;
}

static NSArray *_choices;

+ (NSArray *)defaultChoices
{
	if(!_choices)
	{
		_choices = @[
					 [FTINChoice choiceWithTitle:@"answer_well_structured_coherent".localizedString andImage:nil],
					 [FTINChoice choiceWithTitle:@"answer_little_structured".localizedString andImage:nil],
					 [FTINChoice choiceWithTitle:@"answer_little_coherent".localizedString andImage:nil],
					 [FTINChoice choiceWithTitle:@"answer_none".localizedString andImage:nil]
					 ];
	}
	
	return _choices;
}

@end
