//
//  FTINDescriptiveSkillViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/04.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINDescriptiveSkillViewController.h"
#import "FTINChoice.h"

@interface FTINDescriptiveSkillViewController ()

@end

@implementation FTINDescriptiveSkillViewController

#pragma mark - Super methods

- (instancetype)init
{
    self = [super initWithDelegate:self];
    if (self) {
    }
    return self;
}

#pragma mark - Choice Table View Controller Delegate

- (NSArray *)choicesForChoiceTableViewController:(FTINChoiceTableViewController *)choiceViewController
{
	return [FTINDescriptiveSkillViewController defaultChoices];
}

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
