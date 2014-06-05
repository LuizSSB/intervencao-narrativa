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

#warning TODO implementar certo essa puorra
#import "FTINActivityViewController.h"

@interface FTINPatientViewController ()

@property (weak, nonatomic) IBOutlet UILabel *registrationDateLabel;
@property (weak, nonatomic) IBOutlet UITextField *patientNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *examinerNameTextLabel;
@property (weak, nonatomic) IBOutlet FTINDatePickerTextField *birthdateDatePickerTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sexSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *startActivityButton;
@property (weak, nonatomic) IBOutlet UITableView *activitiesTableView;

- (IBAction)goToNextInput:(UITextField *)sender;

- (IBAction)save:(id)sender;
- (IBAction)startNewActivity:(id)sender;

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

- (IBAction)save:(id)sender
{
	[self.delegate patientViewControllerMustSave:self withName:self.patientNameTextField.text examinerName:self.examinerNameTextLabel.text birthdate:self.birthdateDatePickerTextField.date sex:self.sexSegmentedControl.selectedSegmentIndex handler:^(id result, NSError *error) {
		[NSError alertOnError:error andDoOnSuccess:^{
			[self setupPatientData];
			[self showLocalizedToastText:@"patient_saved"];
		}];
	}];
}

- (IBAction)startNewActivity:(id)sender
{
#warning TODO implementar certo essa porra
	UIViewController *act = [[FTINActivityViewController alloc] init];
	UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:act];
	[self presentViewController:navigation animated:YES completion:nil];
}

- (void)setupPatientData
{
	self.title = [self.delegate patientViewControllerTitle:self];
	
	if(self.isViewLoaded)
	{
		self.registrationDateLabel.text = [[self.delegate patientViewControllerRegistrationDate:self] formattedDateWithStyle:NSDateFormatterShortStyle];
		self.patientNameTextField.text = [self.delegate patientViewControllerPatientName:self];
		self.examinerNameTextLabel.text = [self.delegate patientViewControllerExaminerName:self];
		self.birthdateDatePickerTextField.date = [self.delegate patientViewControllerBirthdate:self];
		self.sexSegmentedControl.selectedSegmentIndex = [self.delegate patientViewControllerSex:self];
		[self.saveButton setTitle:[self.delegate patientViewControllerSaveButtonTitle:self] forState:UIControlStateNormal];
		
		self.activitiesTableView.hidden = self.startActivityButton.hidden = ![self.delegate patientViewControllerShouldShowActivities:self];
	}
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
