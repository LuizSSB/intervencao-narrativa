//
//  FTINArrangementChoiceViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/10.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINArrangementSkillChoiceViewController.h"
#import "FTINChoice.h"

@interface FTINArrangementSkillChoiceViewController ()

@end

@implementation FTINArrangementSkillChoiceViewController

#pragma mark - Super methods

- (instancetype)init
{
    self = [super initWithChoices:[FTINArrangementSkillChoiceViewController defaultChoices]];
    if (self) {
    }
    return self;
}

#pragma mark - Instance methods

- (FTINArrangementSkill)selectedSkill
{
	return (FTINArrangementSkill) self.selectedChoiceIndex;
}

- (void)setSelectedSkill:(FTINArrangementSkill)selectedSkill
{
	self.selectedChoiceIndex = selectedSkill;
}

static NSArray *_choices;

+ (NSArray *)defaultChoices
{
	if(!_choices)
	{
		_choices = @[
					 [FTINChoice choiceWithTitle:@"arranged_no_help".localizedString andImage:nil],
					 [FTINChoice choiceWithTitle:@"arranged_help".localizedString andImage:nil]
					 ];
	}
	
	return _choices;
}

@end
