//
//  FTINDescriptiveSkillViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/04.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINDescriptiveSkillChoiceViewController.h"
#import "FTINChoice.h"

@interface FTINDescriptiveSkillChoiceViewController ()

@end

@implementation FTINDescriptiveSkillChoiceViewController

#pragma mark - Super methods

- (instancetype)init
{
    self = [super initWithChoices:[FTINDescriptiveSkillChoiceViewController defaultChoices]];
    if (self) {
    }
    return self;
}

- (FTINDescriptiveSkill)selectedSkill
{
	return (FTINDescriptiveSkill) self.selectedChoiceIndex;
}

- (void)setSelectedSkill:(FTINDescriptiveSkill)selectedSkill
{
	self.selectedChoiceIndex = selectedSkill;
}

#pragma mark - Instance methods

static NSArray *_choices;

+ (NSArray *)defaultChoices
{
	if(!_choices)
	{
		_choices = @[
					 [FTINChoice choiceWithTitle:@"description_no_help".localizedString andImage:nil],
					 [FTINChoice choiceWithTitle:@"description_partially".localizedString andImage:nil],
					 [FTINChoice choiceWithTitle:@"description_help".localizedString andImage:nil],
					 [FTINChoice choiceWithTitle:@"description_none".localizedString andImage:nil]
					 ];
	}
	
	return _choices;
}

@end
