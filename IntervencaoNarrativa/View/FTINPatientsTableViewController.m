//
//  FTINMasterViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/05/28.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINPatientsTableViewController.h"

@interface FTINPatientsTableViewController ()

@property (nonatomic) FTINPatientTableViewSource *tableViewSource;
@property (nonatomic, readonly) FTINPatientTableViewSource *searchTableViewSource;

- (void)searchPatientsWithSearchTerm:(NSString *)searchTerm;
- (FTINPatientTableViewSource *)createTableViewSourceForTableView:(UITableView *)table;

- (void)addNewPatient:(id)sender;

@end

@implementation FTINPatientsTableViewController

- (void)dealloc
{
	_tableViewSource = nil;
	_searchTableViewSource = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
	
	if(self.visible)
	{
		if(self.searchDisplayController.searchResultsTableView)
		{
			_searchTableViewSource = nil;
		}
	}
	else
	{
		self.tableViewSource = nil;
		_searchTableViewSource = nil;
	}
}

- (void)awakeFromNib
{
	self.clearsSelectionOnViewWillAppear = NO;
	self.preferredContentSize = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewPatient:)];
	
	self.tableViewSource = [self createTableViewSourceForTableView:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.searchDisplayController setActive:NO];
	[self.tableViewSource update];
}

#pragma mark - Instance methods

@synthesize searchTableViewSource = _searchTableViewSource;

- (FTINPatientTableViewSource *)searchTableViewSource
{
	if(!_searchTableViewSource)
	{
		_searchTableViewSource = [self createTableViewSourceForTableView:self.searchDisplayController.searchResultsTableView];
	}
	else
	{
		self.searchDisplayController.searchResultsTableView.delegate = _searchTableViewSource;
		self.searchDisplayController.searchResultsTableView.dataSource = _searchTableViewSource;
	}
	
	return _searchTableViewSource;
}

- (FTINPatientTableViewSource *)createTableViewSourceForTableView:(UITableView *)table
{
	FTINPatientTableViewSource *tableSource = [[FTINPatientTableViewSource alloc] initWithTableView:table andDelegate:self];
	table.delegate = tableSource;
	table.dataSource = tableSource;
	
	return tableSource;
}

- (void)searchPatientsWithSearchTerm:(NSString *)searchTerm
{
	if(searchTerm.length)
	{
		[self.searchTableViewSource getPatientsWithSearchTerm:searchTerm];
	}
	else
	{
		[self.tableViewSource getPatientsWithSearchTerm:searchTerm];
	}
}

- (void)addNewPatient:(id)sender
{
	FTINLaunchNotification(FTINNotificationForMustAddNewPatient());
}

#pragma mark - Search Display Delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	if(searchString.length)
	{
		[self searchPatientsWithSearchTerm:searchString];
		
		return NO;
	}
	
	return YES;
}

#pragma mark - Patient Table View Source Delegate

- (void)patientTableViewSource:(FTINPatientTableViewSource *)source deletedPatient:(Patient *)patient
{
	if(source == self.tableViewSource)
	{
		[self.searchTableViewSource update];
	}
	else
	{
		[self.tableViewSource update];
	}
	
	FTINLaunchNotification(FTINNotificationForDeletedPatient(patient));
}

- (void)patientTableViewSource:(FTINPatientTableViewSource *)source selectedPatient:(Patient *)patient
{
	FTINLaunchNotification(FTINNotificationForSelectedPatient(patient));
}

@end
