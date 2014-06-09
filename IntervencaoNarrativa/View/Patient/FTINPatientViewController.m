//
//  FTINPatientViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINPatientViewController.h"
#import "FTINDatePickerTextField.h"
#import "FTINMainSplitViewControllerDelegate.h"

@interface FTINPatientViewController ()

@property (weak, nonatomic) IBOutlet UILabel *registrationDateLabel;
@property (weak, nonatomic) IBOutlet UITextField *patientNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *examinerNameTextField;
@property (weak, nonatomic) IBOutlet FTINDatePickerTextField *birthdateDatePickerTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sexSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *startActivityButton;
@property (weak, nonatomic) IBOutlet UITableView *activitiesTableView;

- (IBAction)goToNextInput:(UITextField *)sender;
- (IBAction)hideKeyboardsForGodsSake:(id)sender;

- (IBAction)save:(id)sender;
- (IBAction)startNewActivity:(id)sender;

@property (nonatomic, readonly) FTINActivitiesTableViewSource *tableViewSource;

- (void)setupPatientData;

@end

@implementation FTINPatientViewController

#pragma mark - Super methods

- (void)dealloc
{
	_delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setupPatientData];
	
	self.navigationItem.leftBarButtonItem = [FTINMainSplitViewControllerDelegate barButtonToToggleMasterVisibility];
	self.navigationItem.leftItemsSupplementBackButton = YES;
}

#pragma mark - Instance methods

- (void)setDelegate:(id<FTINPatientViewControllerDelegate>)delegate
{
	_delegate = delegate;
	[self setupPatientData];
}

- (IBAction)goToNextInput:(UITextField *)sender
{
	[[self.view viewWithTag:sender.tag + 1] becomeFirstResponder];
}

- (IBAction)hideKeyboardsForGodsSake:(id)sender
{
	[self.patientNameTextField resignFirstResponder];
	[self.examinerNameTextField resignFirstResponder];
}

- (IBAction)save:(id)sender
{
	[self.delegate patientViewControllerMustSave:self withName:self.patientNameTextField.text examinerName:self.examinerNameTextField.text birthdate:self.birthdateDatePickerTextField.date sex:self.sexSegmentedControl.selectedSegmentIndex handler:^(id result, NSError *error) {
		[NSError alertOnError:error andDoOnSuccess:^{
			[self setupPatientData];
			[self showLocalizedToastText:@"patient_saved"];
		}];
	}];
}

- (IBAction)startNewActivity:(id)sender
{
	if([self.delegate respondsToSelector:@selector(patientViewControllerRequestsPatient:)])
	{
		NSURL *activityUrl = [[NSBundle mainBundle] URLForResource:FTINDefaultActivityFileName withExtension:FTINDefaultActivityFileExtension];
		FTINActivityNavigationController *activityViewController = [[FTINActivityNavigationController alloc] initWithActivity:activityUrl andPatient:[self.delegate patientViewControllerRequestsPatient:self] andDelegate:self];
		[self presentViewController:activityViewController animated:YES completion:nil];
	}
}

@synthesize tableViewSource = _tableViewSource;

- (FTINActivitiesTableViewSource *)tableViewSource
{
	if([self.delegate respondsToSelector:@selector(patientViewControllerRequestsPatient:)])
	{
		if(!_tableViewSource)
		{
			Patient *patient = [self.delegate patientViewControllerRequestsPatient:self];
			_tableViewSource = [[FTINActivitiesTableViewSource alloc] initWithPatient:patient andTableView:self.activitiesTableView];
		}
		
		return _tableViewSource;
	}
	else
	{
		return nil;
	}
}

- (void)setupPatientData
{
	self.title = [self.delegate patientViewControllerTitle:self];
	
	if(self.isViewLoaded)
	{
		self.registrationDateLabel.text = [[self.delegate patientViewControllerRegistrationDate:self] formattedDateWithStyle:NSDateFormatterShortStyle];
		self.patientNameTextField.text = [self.delegate patientViewControllerPatientName:self];
		self.examinerNameTextField.text = [self.delegate patientViewControllerExaminerName:self];
		self.birthdateDatePickerTextField.date = [self.delegate patientViewControllerBirthdate:self];
		self.sexSegmentedControl.selectedSegmentIndex = [self.delegate patientViewControllerSex:self];
		[self.saveButton setTitle:[self.delegate patientViewControllerSaveButtonTitle:self] forState:UIControlStateNormal];
		
		self.activitiesTableView.hidden = self.startActivityButton.hidden = ![self.delegate patientViewControllerShouldShowActivities:self];
		self.activitiesTableView.dataSource = self.tableViewSource;
		self.activitiesTableView.delegate = self.tableViewSource;
		[self.tableViewSource update];
	}
}

#pragma mark - Activity Navigation Controller Delegate

- (void)activityNavigationControllerCanceled:(FTINActivityNavigationController *)navigationController
{
	[navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)activityNavigationControllerFinished:(FTINActivityNavigationController *)navigationController
{
	[navigationController dismissViewControllerAnimated:YES completion:^{
		[self.tableViewSource update];
		[self showLocalizedToastText:@"activity_completed"];
	}];
}

- (void)activityNavigationController:(FTINActivityNavigationController *)navigationController failed:(NSError *)error
{
	[navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Subject To PatientTransition Notifications

- (BOOL)allowsEscapeToPatient:(Patient *)patient
{
	return [self.delegate allowsEscapeToPatient:patient];
}

- (BOOL)resonatesWithPatient:(Patient *)patient
{
	return [self.delegate resonatesWithPatient:patient];
}

@end
