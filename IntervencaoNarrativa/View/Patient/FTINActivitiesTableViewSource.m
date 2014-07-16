//
//  FTINActivitiesTableViewSource.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/08.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivitiesTableViewSource.h"
#import "Patient+Complete.h"
#import "Activity+Complete.h"

@interface FTINActivitiesTableViewSource ()
{
	NSMutableArray *_orderedActivities;
	NSIndexPath *_actionIndexPath;
}

@property (nonatomic, readonly) FTINActivityController *controller;

@end

@implementation FTINActivitiesTableViewSource

#pragma mark - Super methods

- (void)dealloc
{
	_patient = nil;
	_parentTableView = nil;
	_orderedActivities = nil;
	_actionIndexPath = nil;
}

#pragma mark - Instance methods

- (instancetype)initWithPatient:(Patient *)patient andTableView:(UITableView *)parentTableView
{
    self = [super init];
    if (self) {
        _patient = patient;
		self.parentTableView = parentTableView;
    }
    return self;
}

- (void)update
{
	[self.parentTableView reloadData];
}

@synthesize controller = _controller;

- (FTINActivityController *)controller
{
	if(!_controller)
	{
		_controller = [[FTINActivityController alloc] initWithDelegate:self];
	}
	
	return _controller;
}

#pragma mark - Table View Source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	_orderedActivities = [NSMutableArray arrayWithArray:self.patient.activitiesInOrder];
	return self.patient.activities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FTINDefaultCellIdentifier];
	
	if(!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:FTINDefaultCellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	Activity *activity = _orderedActivities[indexPath.row];
	cell.textLabel.text = [activity.creationDate formattedDateTimeWithDateStyle:NSDateFormatterFullStyle andTimeStyle:NSDateFormatterShortStyle];
	
	UIColor *textColor = [UIColor blackColor];
	UIColor *detailColor;
	NSString *detailText;
	
	if(activity.failed)
	{
		textColor = detailColor =[UIColor lightGrayColor];
		detailText = @"failed".localizedString;
	}
	else if(activity.finalized)
	{
		detailColor = [UIColor blueColor];
		detailText = @"finished".localizedString;
	}
	else
	{
		detailColor = [UIColor redColor];
		detailText = @"unfinished".localizedString;
	}
	
	cell.textLabel.textColor = textColor;
	cell.detailTextLabel.textColor = detailColor;
	cell.detailTextLabel.text = detailText;
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return .1f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		_actionIndexPath = indexPath;
		[self.controller deleteActivity:_orderedActivities[indexPath.row]];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if([self.delegate respondsToSelector:@selector(activitiesTableViewSource:selectedActivity:)])
	{
		[self.delegate activitiesTableViewSource:self selectedActivity:_orderedActivities[indexPath.row]];
	}
}

#pragma mark - Activity Controller Delegate

- (void)activityController:(FTINActivityController *)controller deletedActivity:(Activity *)Activity error:(NSError *)error
{
	[NSError alertOnError:error andDoOnSuccess:^{
		[self.parentTableView deleteRowsAtIndexPaths:@[_actionIndexPath] withRowAnimation:UITableViewRowAnimationFade];
	}];
}

@end
