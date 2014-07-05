//
//  FTINSubActivitiesTableViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/07/02.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINSubActivitiesTableViewController.h"
#import "FTINActivityDetails.h"
#import "FTINSubActivityDetails.h"
#import "FTINActitivitiesFactory.h"
#import "FTINSubActivityContent.h"
#import "SubActivity+Complete.h"

@interface FTINSubActivitiesTableViewController ()

@property (nonatomic, readonly) NSNumberFormatter *indexFormatter;
@property (nonatomic, readonly) UIPopoverController *parentPopover;

@end

@implementation FTINSubActivitiesTableViewController

#pragma mark - Super methods

- (void)dealloc
{
	_activity = nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = @"activities".localizedString;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.tableView reloadData];
}

#pragma mark - Instance methods

- (instancetype)initWithActivity:(FTINActivityDetails *)activity andDelegate:(id<FTINSubActivitiesTableViewControllerDelegate>)delegate
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
		self.activity = activity;
        self.delegate = delegate;
    }
    return self;
}

@synthesize indexFormatter = _indexFormatter;

- (NSNumberFormatter *)indexFormatter
{
	if(!_indexFormatter)
	{
		_indexFormatter = [[NSNumberFormatter alloc] init];
		_indexFormatter.minimumIntegerDigits = 2;
		_indexFormatter.maximumFractionDigits = 0;
	}
	
	return _indexFormatter;
}

@synthesize parentPopover = _parentPopover;

- (UIPopoverController *)parentPopover
{
	if(!_parentPopover)
	{
		_parentPopover = [[UIPopoverController alloc] initWithContentViewController:[[UINavigationController alloc] initWithRootViewController:self]];
	}
	
	return _parentPopover;
}

- (void)presentAsPopoverFromBarButtonItem:(UIBarButtonItem *)button animated:(BOOL)animated
{
	[self parentPopover];
	
	[self.parentPopover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)dismissPopoverAnimated:(BOOL)animated
{
	[self.parentPopover dismissPopoverAnimated:YES];
}

#pragma mark - Table View Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.activity.subActivities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FTINDefaultCellIdentifier];
	
	if(!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:FTINDefaultCellIdentifier];
	}
	
	FTINSubActivityDetails *subActivity = self.activity.subActivities[indexPath.row];
	cell.textLabel.text = [[self.indexFormatter stringFromNumber:@(indexPath.row + 1)] stringByAppendingFormat:@" - %@", subActivity.content.title];
	cell.detailTextLabel.text = FTINActivityTypeTitle(subActivity.type);
	cell.accessoryType = subActivity.data.completed ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	
	NSString *imageName;
	
	if([self.delegate subActivitesViewController:self shouldMarkSubActivity:subActivity atIndex:indexPath.row])
	{
		imageName = @"selected";
	}
	else
	{
		imageName = @"blank";
	}
	
	cell.imageView.image = [UIImage imageNamed:imageName];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.delegate subActivitiesViewController:self selectedSubActivity:self.activity.subActivities[indexPath.row] atIndex:indexPath.row];
}

@end
