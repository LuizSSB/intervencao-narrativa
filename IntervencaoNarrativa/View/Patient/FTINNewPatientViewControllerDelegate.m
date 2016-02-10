//
//  FTINNewPatientViewControllerDelegate.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINNewPatientViewControllerDelegate.h"
#import "FTINExistingPatientViewControllerDelegate.h"
#import "FTINPatientViewController.h"

@interface FTINNewPatientViewControllerDelegate ()
{
	FTINOperationHandler _insertHandler;
	FTINPatientViewController *_parentViewController;
}

@property (nonatomic, readonly) FTINPatientController *controller;

@end

@implementation FTINNewPatientViewControllerDelegate

#pragma mark - Super methods

- (void)dealloc
{
	_controller = nil;
	_insertHandler = nil;
	_parentViewController = nil;
}

#pragma mark - Instance methods

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
	return @"new_patient".localizedString;
}

- (NSDate *)patientViewControllerRegistrationDate:(FTINPatientViewController *)viewController
{
	return [NSDate date];
}

- (NSString *)patientViewControllerPatientName:(FTINPatientViewController *)viewController
{
	return nil;
}

- (NSString *)patientViewControllerExaminerName:(FTINPatientViewController *)viewController
{
	return nil;
}

- (NSDate *)patientViewControllerBirthdate:(FTINPatientViewController *)viewController
{
	return nil;
}

- (FTINSex)patientViewControllerSex:(FTINPatientViewController *)viewController
{
	return FTINSexMachoMan;
}

- (NSString *)patientViewControllerSaveButtonTitle:(FTINPatientViewController *)viewController
{
	return @"insert_patient".localizedString;
}

- (BOOL)patientViewControllerShouldShowActivities:(FTINPatientViewController *)viewController
{
	return NO;
}

- (void)patientViewControllerMustSave:(FTINPatientViewController *)viewController withName:(NSString *)name examinerName:(NSString *)examiner birthdate:(NSDate *)birthdate sex:(FTINSex)sex handler:(FTINOperationHandler)handler
{
	_parentViewController = viewController;
	_insertHandler = handler;
	[self.controller addPatientWithName:name examiner:examiner sex:sex birthdate:birthdate];
}

#pragma mark - Patient Controller Delegate

- (void)patientController:(FTINPatientController *)controller addedPatient:(Patient *)patient error:(NSError *)error
{
	if(_insertHandler)
	{
		_insertHandler(patient, error);
	}
	
	if(!error)
	{
		id<FTINPatientViewControllerDelegate> newDelegate = [[FTINExistingPatientViewControllerDelegate alloc] initWithPatient:patient];
		_parentViewController.delegate = newDelegate;
		
		FTINLaunchNotification(FTINNotificationForAddedPatient(patient));
	}
	
	_insertHandler = nil;
	_parentViewController = nil;
}

#pragma mark - Subject To PatientTransition Notifications

- (BOOL)allowsEscapeToPatient:(Patient *)patient
{
	return YES;
}

- (BOOL)resonatesWithPatient:(Patient *)patient
{
	return NO;
}

@end
