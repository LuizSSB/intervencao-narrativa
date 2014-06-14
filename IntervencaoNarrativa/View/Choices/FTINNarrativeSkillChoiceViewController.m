//
//  FTINNarrativeSkillChoiceViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/10.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINNarrativeSkillChoiceViewController.h"
#import "FTINChoice.h"

@interface FTINNarrativeSkillChoiceViewController ()

@end

@implementation FTINNarrativeSkillChoiceViewController

#pragma mark - Super methods

- (instancetype)init
{
    self = [super initWithChoices:[FTINNarrativeSkillChoiceViewController defaultChoices]];
    if (self) {
    }
    return self;
}

#pragma mark - Instance methods

- (FTINNarrativeSkill)selectedSkill
{
	return (FTINNarrativeSkill) self.selectedChoiceIndex;
}

- (void)setSelectedSkill:(FTINNarrativeSkill)selectedSkill
{
	self.selectedChoiceIndex = selectedSkill;
}

static NSArray *_choices;

+ (NSArray *)defaultChoices
{
	if(!_choices)
	{
		_choices = @[
					 [FTINChoice choiceWithTitle:@"narrated_no_help".localizedString andImage:nil],
					 [FTINChoice choiceWithTitle:@"narrated_partially".localizedString andImage:nil],
					 [FTINChoice choiceWithTitle:@"narrated_help".localizedString andImage:nil],
					 [FTINChoice choiceWithTitle:@"narrated_none".localizedString andImage:nil]
					 ];
	}
	
	return _choices;
}

@end
