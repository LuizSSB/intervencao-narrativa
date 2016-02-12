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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return [UIFont boldSystemFontOfSize:18].lineHeight * 1.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIFont *headerFont = [UIFont boldSystemFontOfSize:18.0];
	UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, headerFont.lineHeight * 1.5)];
	header.font = headerFont;
	header.textColor = [UIColor whiteColor];
	header.backgroundColor = [FTINStyler barsTintColor];
	header.text = [@"   " stringByAppendingString:FTINActivityTypeTitle((FTINActivityType) section)];
	return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FTINDefaultCellIdentifier];
	
	if(!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:FTINDefaultCellIdentifier];
		cell.textLabel.textColor = [FTINStyler textColor];
		cell.accessoryView = [[UIImageView alloc] init];
	}
	
	FTINSubActivityDetails *subActivity = _activitiesByCategory[@(indexPath.section)][indexPath.row];
	cell.textLabel.text = [[self.indexFormatter stringFromNumber:@(indexPath.row + 1)] stringByAppendingFormat:@" - %@", subActivity.content.title];
	
	if(subActivity.data.finished)
	{
		cell.detailTextLabel.text = [@"grade" localizedStringWithParam:subActivity.data.formattedScore];
	}
	else
	{
		cell.detailTextLabel.text = [NSString string];
	}
	
	NSString *statusImageName;
	
	switch (subActivity.data.status) {
		case FTINActivityStatusCompleted:
			statusImageName = @"check";
			break;
			
		case FTINActivityStatusCompletedButSkipped:
			statusImageName = @"jumpcheck";
			break;
			
		case FTINActivityStatusFailed:
			statusImageName = @"error";
			break;
			
		case FTINActivityStatusIncompletePreviouslySkipped:
		case FTINActivityStatusIncomplete:
			statusImageName = nil;
			break;
			
		case FTINActivityStatusSkipped:
			statusImageName = @"jump";
			break;
			
		default:
			NSAssert(NO, @"Falta tratar um status.");
			break;
	}
	[(UIImageView *)cell.accessoryView setImage:[UIImage lssb_imageNamed:statusImageName]];
	[cell.accessoryView sizeToFit];
	
	NSString *imageName;
	
	if([self.delegate subActivitesViewController:self shouldMarkSubActivity:subActivity atIndex:indexPath.row])
	{
		imageName = @"selected";
	}
	else
	{
		imageName = @"blank";
	}
	
	cell.imageView.image = [UIImage lssb_imageNamed:imageName];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	FTINSubActivityDetails *subActivity = _activitiesByCategory[@(indexPath.section)][indexPath.row];
	[self.delegate subActivitiesViewController:self selectedSubActivity:subActivity atIndex:[self.activity.subActivities indexOfObject:subActivity]];
}

@end
