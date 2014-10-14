//
//  FTINChoiceTableViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/04.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINChoiceViewController.h"
#import "FTINChoice.h"

CGSize const FTINChoicePopoverMaximumSize = {320.f, 450.f};

@interface FTINChoiceViewController ()
{
	NSMutableSet *_selectedChoicesIndexes;
}

@property (nonatomic, readonly) UIPopoverController *parentPopover;

@end

@implementation FTINChoiceViewController

#pragma mark - Super methods

- (void)dealloc
{
	_choices = nil;
	_selectedChoicesIndexes = nil;
	_parentPopover = nil;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	
	if(!self.visible)
	{
		_parentPopover = nil;
	}
}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
		[self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.tableView.rowHeight = FTINDefaultChoiceRowHeight;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}

#pragma mark - Table view source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.choices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FTINDefaultCellIdentifier];
    
	if(!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:FTINDefaultCellIdentifier];
	}
	
	FTINChoice *choice = self.choices[indexPath.row];
	cell.textLabel.text = choice.title;
	cell.detailTextLabel.text = choice.detail;
	cell.imageView.image = choice.image;
	cell.accessoryType = [self isIndexChosen:indexPath.row] ? UITableViewCellAccessoryCheckmark : UITableViewCellEditingStyleNone;
	
	// HACK Luiz: Gambiwambi para ocultar a última linha da tabela
	if(_parentPopover)
	{
		cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, indexPath.row == self.choices.count - 1 ? 1000.f : 0.f);
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if([self isIndexChosen:indexPath.row])
	{
		[self rejectItemAtIndex:indexPath.row];
	}
	else if([self canChooseQuestionAt:indexPath.row])
	{
		[self chooseItemAtIndex:indexPath.row];
	}
}

#pragma mark - Instance methods

- (instancetype)initWithChoices:(NSArray *)choices
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
		[self setup];
		self.choices = choices;
    }
    return self;
}

- (void)setup
{
	_selectedChoicesIndexes = [NSMutableSet set];
	self.maximumChoices = NSIntegerMax;
}

- (BOOL)canChooseQuestionAt:(NSInteger)index
{
	if(self.selectedChoicesIndexes.count >= self.maximumChoices)
	{
		[self showToastText:[@"maximum_reached" localizedStringWithIntParam:self.maximumChoices]];
		return NO;
	}
	
	return YES;
}

- (void)setChoices:(NSArray *)choices
{
	if([choices[0] isKindOfClass:[FTINChoice class]])
	{
		_choices = choices;
	}
	else
	{
		NSMutableArray *correctChoices = [NSMutableArray array];
		
		for (NSObject *choice in choices) {
			[correctChoices addObject:[FTINChoice choiceWithTitle:choice.description andImage:nil]];
		}
		
		_choices = correctChoices;
	}
	
	
	if(self.isViewLoaded)
	{
		for (NSNumber *choice in [NSSet setWithSet:_selectedChoicesIndexes])
		{
			if(choice.integerValue >= _choices.count)
			{
				[_selectedChoicesIndexes removeObject:choice];
			}
		}
		
		[self.tableView reloadData];
	}
}

- (NSDictionary *)getSelectedChoices
{
	NSMutableDictionary *choices = [NSMutableDictionary dictionary];
	
	for (NSNumber *choice in _selectedChoicesIndexes)
	{
		[choices setObject:self.choices[choice.integerValue] forKey:choice];
	}
	
	return choices;
}

- (void)chooseItemAtIndex:(NSInteger)index
{
	if(index > self.choices.count || index < 0)
	{
		return;
	}
	
	NSNumber *choice = @(index);
	if(![_selectedChoicesIndexes containsObject:choice])
	{
		[_selectedChoicesIndexes addObject:choice];
		[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
		
		if([self.delegate respondsToSelector:@selector(choiceViewController:choseItemAtIndex:withMetadata:)])
		{
			[self.delegate choiceViewController:self choseItemAtIndex:index withMetadata:self.choices[index]];
		}
	}
}

- (void)rejectItemAtIndex:(NSInteger)index
{
	if(index > self.choices.count || index < 0)
	{
		return;
	}
	
	NSNumber *choice = @(index);
	if([_selectedChoicesIndexes containsObject:choice])
	{
		[_selectedChoicesIndexes removeObject:choice];
		[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
		
		if([self.delegate respondsToSelector:@selector(choiceViewController:rejectedItemAtIndex:withMetadata:)])
		{
			[self.delegate choiceViewController:self rejectedItemAtIndex:index withMetadata:self.choices[index]];
		}
	}
}

- (BOOL)isIndexChosen:(NSInteger)index
{
	return [_selectedChoicesIndexes containsObject:@(index)];
}

- (BOOL)hasSelectedChoice
{
	return _selectedChoicesIndexes.count > 0;
}

@synthesize parentPopover = _parentPopover;

- (UIPopoverController *)parentPopover
{
	if(!_parentPopover)
	{
		_parentPopover = [[UIPopoverController alloc] initWithContentViewController:self];
	}
	
	return _parentPopover;
}

- (void)presentAsPopoverFromBarButtonItem:(UIBarButtonItem *)button animated:(BOOL)animated
{
	[self parentPopover];
	CGFloat popoverHeight = MIN(FTINChoicePopoverMaximumSize.height, self.tableView.rowHeight * self.choices.count + self.navigationController.navigationBar.frame.size.height);
	
	self.tableView.scrollEnabled = popoverHeight == FTINChoicePopoverMaximumSize.height;
	
	self.parentPopover.popoverContentSize = CGSizeMake(MAX(FTINChoicePopoverMaximumSize.width, self.popoverWidth), popoverHeight);
	
	[self.parentPopover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)dismissPopoverAnimated:(BOOL)animated
{
	[self.parentPopover dismissPopoverAnimated:YES];
}

@end
