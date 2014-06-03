//
//  FTINNotifications.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const FTINNotificationMustAddNewPatient;
extern NSString * const FTINNotificationDeletedPatient;
extern NSString * const FTINNotificationSelectedPatient;

extern NSString * const kFTINParamPatient;

@class Patient;

@interface FTINNotifications : NSObject

NSNotification * FTINCreateNotification(NSString *name, id obj, NSDictionary *dictionary);
NSNotification * FTINNotificationForMustAddNewPatient();
NSNotification * FTINNotificationForDeletedPatient(Patient *patient);
NSNotification * FTINNotificationForSelectedPatient(Patient *patient);

void FTINLaunchNotification(NSNotification *notification);

@end