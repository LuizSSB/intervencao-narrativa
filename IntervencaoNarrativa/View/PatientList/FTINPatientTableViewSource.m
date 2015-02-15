//
//  FTINPatientTableViewSource.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINPatientTableViewSource.h"
#import "Patient.h"

@interface FTINPatientTableViewSource ()
{
	NSMutableArray *_patients;
	NSIndexPath *_actionIndexPath;
	NSString *_lastSearchTerm;
}

@property (nonatomic, readonly) FTINPatientController *patientController;

@end

@implementation FTINPatientTableViewSource

#pragma mark - Super methods

- (void)dealloc
{
	_actionIndexPath = nil;
	_patients = nil;
	_patientController = nil;
	_lastSearchTerm = nil;
}

#pragma mark - Instance methods

- (instancetype)initWithTableView:(UITableView *)tableView andDelegate:(id<FTINPatientTableViewSourceDelegate>)delegate
{
    self = [super init];
    if (self) {
		self.parentTableView = tableView;
        self.delegate = delegate;
    }
    return self;
}

- (void)update
{
	[self getPatientsWithSearchTerm:_lastSearchTerm];
}

- (void)getPatientsWithSearchTerm:(NSString *)searchTerm
{
	_lastSearchTerm = searchTerm;
	[self.patientController getPatients:searchTerm];
}

@synthesize patientController = _patientController;

- (FTINPatientController *)patientController
{
	if(!_patientController)
	{
		_patientController = [[FTINPatientController alloc] initWithDelegate:self];
	}
	
	return _patientController;
}

#pragma mark - Table View Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _patients.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	
	if(!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
		cell.textLabel.textColor = cell.detailTextLabel.textColor = [FTINStyler textColor];
	}
	
	Patient *patient = _patients[indexPath.row];
	cell.textLabel.text = patient.name;
	cell.detailTextLabel.text = [@"examiner_name" localizedStringWithParam:patient.examiner];
	
	return cell;
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
		[self.patientController removePatient:_patients[indexPath.row]];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.delegate patientTableViewSource:self selectedPatient:_patients[indexPath.row]];
}

#pragma mark - Patient Controller Delegate

- (void)patientController:(FTINPatientController *)controller gotPatients:(NSArray *)patients error:(NSError *)error
{
	[NSError alertOnError:error andDoOnSuccess:^{
		_patients = [NSMutableArray arrayWithArray:patients];
		[self.parentTableView reloadData];
	}];
}

- (void)patientController:(FTINPatientController *)controller removedPatient:(Patient *)patient error:(NSError *)error
{
	[NSError alertOnError:error andDoOnSuccess:^{
		[self.delegate patientTableViewSource:self deletedPatient:patient];
		[_patients removeObjectAtIndex:_actionIndexPath.row];
		
		[self.parentTableView deleteRowsAtIndexPaths:@[_actionIndexPath] withRowAnimation:UITableViewRowAnimationFade];
	}];
}

@end
