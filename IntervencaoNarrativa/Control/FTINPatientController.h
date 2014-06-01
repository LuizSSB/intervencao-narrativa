//
//  FTINPatientController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Patient, FTINPatientController;

@protocol FTINPatientControllerDelegate <NSObject>

@optional

- (void)patientController:(FTINPatientController *)controller gotPatients:(NSArray *)patients error:(NSError *)error;

- (void)patientController:(FTINPatientController *)controller addedPatient:(Patient *)patient error:(NSError *)error;

- (void)patientController:(FTINPatientController *)controller editedPatient:(Patient *)patient error:(NSError *)error;

- (void)patientController:(FTINPatientController *)controller removedPatient:(Patient *)patient error:(NSError *)error;

@end

@interface FTINPatientController : NSObject

@property (nonatomic, weak) id<FTINPatientControllerDelegate> delegate;

+ (BOOL)isPatientDataValidWithName:(NSString *)name examiner:(NSString *)examiner sex:(FTINSex)sex birthdate:(NSDate *)date;

- (id)initWithDelegate:(id<FTINPatientControllerDelegate>)delegate;

- (void)addPatientWithName:(NSString *)name examiner:(NSString *)examiner sex:(FTINSex)sex birthdate:(NSDate *)birthdate;

- (void)editPatient:(Patient *)patient withName:(NSString *)name examiner:(NSString *)examiner sex:(FTINSex)sex birthdate:(NSDate *)date;

- (void)getPatients:(NSString *)name;

@end
