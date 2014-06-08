//
//  FTINPatientTransitionsObserver.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINPatientTransitionsObserver.h"
#import "FTINMainSplitViewControllerDelegate.h"
#import "FTINPatientViewController.h"
#import "FTINNewPatientViewControllerDelegate.h"
#import "FTINExistingPatientViewControllerDelegate.h"
#import "FTINSubjectToPatientTransitionNotifications.h"

@interface FTINPatientTransitionsObserver ()
{
	UIViewController *_currentViewController;
	Patient *_currentPatient;
}

- (void)pushPatientViewControllerFrom:(UIViewController *)originViewController withPatient:(Patient *)patient;

- (void)handleMustAddPatientNotification:(NSNotification *)notification;
- (void)handleDeletedPatientNotification:(NSNotification *)notification;
- (void)handleSelectedPatientNotification:(NSNotification *)notification;

@end

@implementation FTINPatientTransitionsObserver

static FTINPatientTransitionsObserver *_observer;

#pragma mark - Instance methods

+ (void)setup
{
	_observer = [[FTINPatientTransitionsObserver alloc] init];
	
	[[NSNotificationCenter defaultCenter] addObserver:_observer selector:@selector(handleMustAddPatientNotification:) name:FTINNotificationMustAddNewPatient object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:_observer selector:@selector(handleDeletedPatientNotification:) name:FTINNotificationDeletedPatient object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:_observer selector:@selector(handleSelectedPatientNotification:) name:FTINNotificationSelectedPatient object:nil];
}

- (void)pushPatientViewControllerFrom:(UIViewController *)originViewController withPatient:(Patient *)patient
{
	FTINPatientViewController *patientViewController = [[FTINPatientViewController alloc] init];
	
	if(patient)
	{
		patientViewController.delegate = [[FTINExistingPatientViewControllerDelegate alloc] initWithPatient:patient];
	}
	else
	{
		patientViewController.delegate = [[FTINNewPatientViewControllerDelegate alloc] init];
	}
	
	UINavigationController *navigator;
	
	if([originViewController isKindOfClass:[UINavigationController class]])
	{
		navigator = (id)originViewController;
	}
	else
	{
		navigator = originViewController.navigationController;
	}
	
	[navigator popToRootViewControllerAnimated:NO];
	[navigator pushViewController:patientViewController animated:YES];
	
	[FTINMainSplitViewControllerDelegate setMasterViewControllerVisible:NO];
}

#pragma mark - Notification Handling

- (void)handleMustAddPatientNotification:(NSNotification *)notification
{
	[FTINMainSplitViewControllerDelegate masterViewControllerVisible];
	
	UIViewController *current = [FTINMainSplitViewControllerDelegate currentDetailViewController];
	
	if([current conformsToProtocol:@protocol(FTINSubjectToPatientTransitionNotifications)])
	{
		id<FTINSubjectToPatientTransitionNotifications> subject = (id)current;
		
		if([subject allowsEscapeToPatient:notification.object])
		{
			[self pushPatientViewControllerFrom:current withPatient:nil];
		}
		else
		{
			_currentPatient = notification.object;
			_currentViewController = current;
			
			[[UIAlertView alertWithConfirmation:@"leave_current_screen".localizedString delegate:self] show];
		}
	}
}

- (void)handleDeletedPatientNotification:(NSNotification *)notification
{
	UIViewController *current = [FTINMainSplitViewControllerDelegate currentDetailViewController];
	
	if([current conformsToProtocol:@protocol(FTINSubjectToPatientTransitionNotifications)])
	{
		id<FTINSubjectToPatientTransitionNotifications> subject = (id)current;
		
		if([subject resonatesWithPatient:notification.object])
		{
			[current.navigationController popToRootViewControllerAnimated:YES];
		}
	}
}

- (void)handleSelectedPatientNotification:(NSNotification *)notification
{
	UIViewController *current = [FTINMainSplitViewControllerDelegate currentDetailViewController];
	
	if([current conformsToProtocol:@protocol(FTINSubjectToPatientTransitionNotifications)])
	{
		id<FTINSubjectToPatientTransitionNotifications> subject = (id)current;
		
		if(![subject resonatesWithPatient:notification.object])
		{
			if([subject allowsEscapeToPatient:notification.object])
			{
				[self pushPatientViewControllerFrom:current withPatient:notification.object];
			}
			else
			{
				_currentPatient = notification.object;
				_currentViewController = current;
				
				[[UIAlertView alertWithConfirmation:@"leave_current_screen".localizedString delegate:self] show];
			}
		}
	}
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex != alertView.cancelButtonIndex)
	{
		[self pushPatientViewControllerFrom:_currentViewController withPatient:_currentPatient];
		_currentPatient = nil;
		_currentViewController = nil;
	}
}

@end
