//
//  FTINExistingPatientViewControllerDelegate.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINExistingPatientViewControllerDelegate.h"
#import "Patient+Complete.h"

@interface FTINExistingPatientViewControllerDelegate ()
{
	FTINOperationHandler _editHandler;
}

@property (nonatomic, readonly) FTINPatientController *controller;

@end

@implementation FTINExistingPatientViewControllerDelegate

#pragma mark - Super methods

- (void)dealloc
{
	_patient = nil;
	_editHandler = nil;
	_controller = nil;
}

#pragma mark - Instance methods

- (instancetype)initWithPatient:(Patient *)patient
{
    self = [super init];
    if (self) {
        self.patient = patient;
    }
    return self;
}

@synthesize controller = _controller;

- (FTINPatientController *)controller
{
	if(!_controller)
	{
		_controller = [[FTINPatientController alloc] initWithDelegate:self];
	}
	
	return _controller;
}

#pragma mark - Patient View Controller Delegate

- (NSString *)patientViewControllerTitle:(FTINPatientViewController *)viewController
{
	return self.patient.name;
}

- (NSDate *)patientViewControllerRegistrationDate:(FTINPatientViewController *)viewController
{
	return self.patient.creationDate;
}

- (NSString *)patientViewControllerPatientName:(FTINPatientViewController *)viewController
{
	return self.patient.name;
}

- (NSString *)patientViewControllerExaminerName:(FTINPatientViewController *)viewController
{
	return self.patient.examiner;
}

- (NSDate *)patientViewControllerBirthdate:(FTINPatientViewController *)viewController
{
	return self.patient.birthdate;
}

- (FTINSex)patientViewControllerSex:(FTINPatientViewController *)viewController
{
	return self.patient.sex;
}

- (NSString *)patientViewControllerSaveButtonTitle:(FTINPatientViewController *)viewController
{
	return @"save".localizedString;
}

- (BOOL)patientViewControllerShouldShowActivities:(FTINPatientViewController *)viewController
{
	return YES;
}

- (void)patientViewControllerMustSave:(FTINPatientViewController *)viewController withName:(NSString *)name examinerName:(NSString *)examiner birthdate:(NSDate *)birthdate sex:(FTINSex)sex handler:(FTINOperationHandler)handler
{
	_editHandler = handler;
	[self.controller editPatient:self.patient withName:name examiner:examiner sex:sex birthdate:birthdate];
}

- (Patient *)patientViewControllerRequestsPatient:(FTINPatientViewController *)patient
{
	return self.patient;
}

#pragma mark - Patient Controller Delegate

- (void)patientController:(FTINPatientController *)controller editedPatient:(Patient *)patient error:(NSError *)error
{
	if(_editHandler)
	{
		_editHandler(patient, error);
	}

	if(!error)
	{
		self.patient = patient;
	}
}

#pragma mark - Subject To PatientTransition Notifications

- (BOOL)allowsEscapeToPatient:(Patient *)patient
{
	return YES;
}

- (BOOL)resonatesWithPatient:(Patient *)patient
{
	return [patient.name isEqualToString:self.patient.name] || patient.name == self.patient.name;
}

@end
