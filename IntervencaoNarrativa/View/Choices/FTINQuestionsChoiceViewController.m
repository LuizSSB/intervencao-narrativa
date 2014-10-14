//
//  FTINQuestionsChoiceViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/07/17.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINQuestionsChoiceViewController.h"
#import "FTINWhyGameQuestion.h"
#import "FTINChoice.h"

NSString * const FTINQuestionsChoiceCellIdConfirmation = @"Confirm";

typedef enum : NSUInteger {
    FTINQuestionsChoiceTableSectionQuestions = 0,
    FTINQuestionsChoiceTableSectionConfirm
} FTINQuestionsChoiceTableSection;

@interface FTINQuestionsChoiceViewController ()
{
	NSArray *_questions;
}

@end

@implementation FTINQuestionsChoiceViewController

#pragma mark - Super methods

- (void)dealloc
{
	_questions = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.section == FTINQuestionsChoiceTableSectionQuestions)
	{
		return [super tableView:tableView cellForRowAtIndexPath:indexPath];
	}
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FTINQuestionsChoiceCellIdConfirmation];
	
	if(!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FTINQuestionsChoiceCellIdConfirmation];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:cell.textLabel.font.pointSize];
		cell.textLabel.text = @"use_questions".localizedString;
	}
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section == FTINQuestionsChoiceTableSectionQuestions)
	{
		return [super tableView:tableView numberOfRowsInSection:section];
	}
	
	return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.section == FTINQuestionsChoiceTableSectionQuestions)
	{
		[super tableView:tableView didSelectRowAtIndexPath:indexPath];
		return;
	}
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if(self.hasSelectedChoice)
	{
		[self.questionsDelegate questionsChoiceViewController:self choseQuestions:[self getSelectedQuestions]];
	}
	else
	{
		[self showLocalizedToastText:@"must_select_questions"];
	}
}

- (void)setup
{
	[super setup];
	self.maximumChoices = 6;
}

#pragma mark - Instance methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(section == FTINQuestionsChoiceTableSectionQuestions)
	{
		return @"select_questions".localizedString;
	}
	
	return [NSString string];
}

- (void)setChoices:(NSArray *)choices
{
	if([choices[0] isKindOfClass:[FTINWhyGameQuestion class]])
	{
		_questions = choices;
		
		NSMutableArray *newChoices = [NSMutableArray array];

		for (FTINWhyGameQuestion *question in _questions)
		{
			[newChoices addObject:[FTINChoice choiceWithTitle:question.question andDetail:question.answer andImage:nil]];
		}
		
		choices = newChoices;
	}
	
	return [super setChoices:choices];
}

- (NSArray *)getSelectedQuestions
{
	NSMutableArray *selected = [NSMutableArray array];
	
	for (NSNumber *idx in [self getSelectedChoices].allKeys)
	{
		[selected addObject:_questions[idx.integerValue]];
	}
	
	return selected;
}

@end
