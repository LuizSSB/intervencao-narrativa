//
//  FTINCoherenceChoiceViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINCoherenceChoiceViewController.h"
#import "FTINChoice.h"

@interface FTINCoherenceChoiceViewController ()

@end

@implementation FTINCoherenceChoiceViewController

#pragma mark - Super methods

- (void)dealloc
{
	_choiceTextPrefix = nil;
}

#pragma mark - Instance methods

- (instancetype)initWithChoiceTextPrefix:(NSString *)choiceTextPrefix
{
    self = [super init];
    if (self) {
		self.title = choiceTextPrefix;
        self.choiceTextPrefix = choiceTextPrefix;
    }
    return self;
}

- (FTINCoherence)selectedCoherence
{
	return (FTINCoherence) self.selectedChoiceIndex;
}

- (void)setSelectedCoherence:(FTINCoherence)selectedCoherence
{
	self.selectedChoiceIndex = selectedCoherence;
}

- (void)setChoiceTextPrefix:(NSString *)choiceTextPrefix
{
	_choiceTextPrefix = choiceTextPrefix;
	
	self.choices = @[
					 [FTINChoice choiceWithTitle:[choiceTextPrefix stringByAppendingString:@"coherenceskill_0".localizedString] andImage:nil],
					 [FTINChoice choiceWithTitle:[choiceTextPrefix stringByAppendingString:@"coherenceskill_1".localizedString] andImage:nil]
					 ];
}

@end
