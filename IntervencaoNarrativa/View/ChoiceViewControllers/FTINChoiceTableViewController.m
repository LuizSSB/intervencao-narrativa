//
//  FTINChoiceTableViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/04.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINChoiceTableViewController.h"
#import "FTINChoice.h"

@interface FTINChoiceTableViewController ()
{
	NSMutableSet *_selectedChoices;
}

@end

@implementation FTINChoiceTableViewController

#pragma mark - Super methods

- (void)dealloc
{
	_choices = nil;
	_selectedChoices = nil;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	
	if(!self.visible)
	{
		_choices = nil;
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	_choices = [self.delegate choicesForChoiceTableViewController:self];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FTINDefaultCellIdentifier.description];
    
	if(!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FTINDefaultCellIdentifier.description];
	}
	
	FTINChoice *choice = self.choices[indexPath.row];
	cell.textLabel.text = choice.title;
	cell.imageView.image = choice.image;	
	cell.accessoryType = [self isIndexChosen:indexPath.row] ? UITableViewCellAccessoryCheckmark : UITableViewCellEditingStyleNone;
    
	cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, indexPath.row == self.choices.count - 1 ? 1000.f : 0.f);
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if([self isIndexChosen:indexPath.row])
	{
		[self rejectItemAtIndex:indexPath.row];
	}
	else
	{
		[self chooseItemAtIndex:indexPath.row];
	}
}

#pragma mark - Instance methods

- (instancetype)initWithDelegate:(id<FTINChoiceTableViewControllerDelegate>)delegate
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _delegate = delegate;
		_selectedChoices = [NSMutableSet set];
    }
    return self;
}

- (void)setDelegate:(id<FTINChoiceTableViewControllerDelegate>)delegate
{
	_delegate = delegate;
	
	if(self.isViewLoaded)
	{
		_choices = [delegate choicesForChoiceTableViewController:self];
		
		for (NSNumber *choice in [NSSet setWithSet:_selectedChoices])
		{
			if(choice.integerValue >= _choices.count)
			{
				[_selectedChoices removeObject:choice];
			}
		}
		
		[self.tableView reloadData];
	}
}

- (NSDictionary *)getSelectedChoices
{
	NSMutableDictionary *choices = [NSMutableDictionary dictionary];
	
	for (NSNumber *choice in choices)
	{
		[choices setObject:choice forKey:self.choices[choice.integerValue]];
	}
	
	return choices;
}

- (void)chooseItemAtIndex:(NSInteger)index
{
	if(index > self.choices.count)
	{
		return;
	}
	
	NSNumber *choice = @(index);
	if(![_selectedChoices containsObject:choice])
	{
		[_selectedChoices addObject:choice];
		[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
		
		if([self.delegate respondsToSelector:@selector(choiceTableViewController:choseItemAtIndex:withMetadata:)])
		{
			[self.delegate choiceTableViewController:self choseItemAtIndex:index withMetadata:self.choices[index]];
		}
	}
}

- (void)rejectItemAtIndex:(NSInteger)index
{
	if(index > self.choices.count)
	{
		return;
	}
	
	NSNumber *choice = @(index);
	if([_selectedChoices containsObject:choice])
	{
		[_selectedChoices removeObject:choice];
		[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
		
		if([self.delegate respondsToSelector:@selector(choiceTableViewController:rejectedItemAtIndex:withMetadata:)])
		{
			[self.delegate choiceTableViewController:self rejectedItemAtIndex:index withMetadata:self.choices[index]];
		}
	}
}

- (BOOL)isIndexChosen:(NSInteger)index
{
	return [_selectedChoices containsObject:@(index)];
}

@end
