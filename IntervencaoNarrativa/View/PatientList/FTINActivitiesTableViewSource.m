//
//  FTINActivitiesTableViewSource.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/08.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivitiesTableViewSource.h"
#import "Patient+Complete.h"
#import "Acitivity+Complete.h"

@interface FTINActivitiesTableViewSource ()
{
	NSArray *_orderedActivities;
}

@end

@implementation FTINActivitiesTableViewSource

#pragma mark - Super methods

- (void)dealloc
{
	_patient = nil;
	_parentTableView = nil;
	_orderedActivities = nil;
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

#pragma mark - Table View Source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	_orderedActivities = self.patient.activitiesInOrder;
	return self.patient.activities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FTINDefaultCellIdentifier.description];
	
	if(!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:FTINDefaultCellIdentifier.description];
	}
	
	Activity *activity = _orderedActivities[indexPath.row];
	cell.textLabel.text = [activity.creationDate formattedDateTimeWithDateStyle:NSDateFormatterFullStyle andTimeStyle:NSDateFormatterShortStyle];
	cell.detailTextLabel.text = activity.title;
	
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if([self.delegate respondsToSelector:@selector(activitiesTableViewSource:selectedActivity:)])
	{
		[self.delegate activitiesTableViewSource:self selectedActivity:_orderedActivities[indexPath.row]];
	}
}

@end
