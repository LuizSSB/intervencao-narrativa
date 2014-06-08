//
//  FTINSingleChoiceViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/04.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINSingleChoiceViewController.h"

@interface FTINSingleChoiceViewController ()

@end

@implementation FTINSingleChoiceViewController

#pragma mark - Super methods

- (instancetype)initWithChoices:(NSArray *)choices
{
    self = [super initWithChoices:choices];
    if (self) {
        _selectedChoiceIndex = -1;
    }
    return self;
}

- (void)chooseItemAtIndex:(NSInteger)index
{
	if(index < self.choices.count && index != self.selectedChoiceIndex)
	{
		NSInteger prevIndex = self.selectedChoiceIndex;
		_selectedChoiceIndex = index;
		
		[self rejectItemAtIndex:prevIndex];
		[super chooseItemAtIndex:index];
	}
}

- (void)rejectItemAtIndex:(NSInteger)index
{
	if(index < 0)
	{
		if(self.allowsUnselection && index == self.selectedChoiceIndex)
		{
			[super rejectItemAtIndex:self.selectedChoiceIndex];
			_selectedChoiceIndex = -1;
		}
	}
	else if(index != self.selectedChoiceIndex || self.allowsUnselection)
	{
		[super rejectItemAtIndex:index];
		
		if(index == self.selectedChoiceIndex)
		{
			_selectedChoiceIndex = -1;
		}
	}
}

- (void)setDelegate:(id<FTINChoiceTableViewControllerDelegate>)delegate
{
	[super setDelegate:delegate];
	
	if(self.selectedChoiceIndex >= 0)
	{
		self.selectedChoiceIndex = MIN(self.selectedChoiceIndex, self.choices.count - 1);
	}
}

#pragma mark - Instance methods

- (void)setSelectedChoiceIndex:(NSInteger)selectedChoiceIndex
{
	[self chooseItemAtIndex:selectedChoiceIndex];
}

- (FTINChoice *)selectedChoice
{
	return self.selectedChoiceIndex < 0 ? nil : self.choices[self.selectedChoiceIndex];
}

- (void)setSelectedChoice:(FTINChoice *)selectedChoice
{
	if([self.choices containsObject:selectedChoice])
	{
		self.selectedChoiceIndex = [self.choices indexOfObject:selectedChoice];
	}
}

@end
