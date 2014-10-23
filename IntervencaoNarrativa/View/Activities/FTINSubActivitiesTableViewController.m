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
{
	NSDictionary *_activitiesByCategory;
}

@property (nonatomic, readonly) NSNumberFormatter *indexFormatter;
@property (nonatomic, readonly) UIPopoverController *parentPopover;

@end

@implementation FTINSubActivitiesTableViewController

#pragma mark - Super methods

- (void)dealloc
{
	_activity = nil;
	_activitiesByCategory = nil;
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
		_parentPopover = [[UIPopoverController alloc] initWithContentViewController:self];
	}
	
	return _parentPopover;
}

- (void)setActivity:(FTINActivityDetails *)activity
{
	_activity = activity;
	
	NSMutableDictionary *activitiesByCategory = [NSMutableDictionary dictionary];
	
	for (FTINSubActivityDetails *subActivity in activity.subActivities)
	{
		NSNumber *key = @(subActivity.type);
		
		if(!activitiesByCategory[key])
		{
			activitiesByCategory[key] = [NSMutableArray array];
		}
		
		[activitiesByCategory[key] addObject:subActivity];
	}
	
	_activitiesByCategory = activitiesByCategory;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return FTINActivityTypeGetValues().count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_activitiesByCategory[@(section)] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return FTINActivityTypeTitle((FTINActivityType) section);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FTINDefaultCellIdentifier];
	
	if(!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:FTINDefaultCellIdentifier];
	}
	
	FTINSubActivityDetails *subActivity = _activitiesByCategory[@(indexPath.section)][indexPath.row];
	cell.textLabel.text = [[self.indexFormatter stringFromNumber:@(indexPath.row + 1)] stringByAppendingFormat:@" - %@", subActivity.content.title];
	cell.detailTextLabel.text = FTINActivityTypeTitle(subActivity.type);
	cell.accessoryView = nil;
	
	if(subActivity.data.skipped)
	{
		cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jump"]];
	}
	else if(subActivity.data.failed)
	{
		cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
	}
	else if(subActivity.data.completed)
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else
	{
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
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
	
	FTINSubActivityDetails *subActivity = _activitiesByCategory[@(indexPath.section)][indexPath.row];
	[self.delegate subActivitiesViewController:self selectedSubActivity:subActivity atIndex:[self.activity.subActivities indexOfObject:subActivity]];
}

@end
