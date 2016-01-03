//
//  FTINNotifications.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINNotifications.h"

NSString * const FTINNotificationMustAddNewPatient = @"MustAddNewPatientNotification";
NSString * const FTINNotificationDeletedPatient = @"PatientDeletedNotification";
NSString * const FTINNotificationSelectedPatient = @"PatientSelectedNotification";
NSString * const FTINNotificationAddedPatient = @"PatientAddedNotification";
NSString * const FTINNotificationUpdatedPatient = @"PatientUpdatedNotification";

NSString * const kFTINParamPatient = @"PatientParam";

@interface FTINNotifications ()

@end

@implementation FTINNotifications

#pragma mark - Utils

NSNotification * FTINCreateNotification(NSString *name, id obj, NSDictionary *dictionary)
{
	return [NSNotification notificationWithName:name object:obj userInfo:dictionary];
}

#pragma mark - Notifications Factories

NSNotification * FTINNotificationForAddedPatient(Patient *patient)
{
	NSDictionary *params = @{kFTINParamPatient:patient};
	return FTINCreateNotification(FTINNotificationAddedPatient, patient, params);
}

NSNotification * FTINNotificationForUpdatedPatient(Patient *patient)
{
	NSDictionary *params = @{kFTINParamPatient:patient};
	return FTINCreateNotification(FTINNotificationUpdatedPatient, patient, params);
}

NSNotification * FTINNotificationForMustAddNewPatient()
{
	return FTINCreateNotification(FTINNotificationMustAddNewPatient, nil, nil);
}

NSNotification * FTINNotificationForDeletedPatient(Patient *patient)
{
	NSDictionary *params = @{kFTINParamPatient:patient};
	return FTINCreateNotification(FTINNotificationDeletedPatient, patient, params);
}

NSNotification * FTINNotificationForSelectedPatient(Patient *patient)
{
	NSDictionary *params = @{kFTINParamPatient:patient};
	return FTINCreateNotification(FTINNotificationSelectedPatient, patient, params);
}

void FTINLaunchNotification(NSNotification *notification)
{
	[[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
