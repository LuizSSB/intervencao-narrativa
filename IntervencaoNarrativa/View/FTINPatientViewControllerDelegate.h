//
//  FTINPatientViewControllerDelegate.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FTINPatientViewController;

@protocol FTINPatientViewControllerDelegate <NSObject>

- (NSString *)patientViewControllerTitle:(FTINPatientViewController *)viewController;
- (NSDate *)patientViewControllerRegistrationDate:(FTINPatientViewController *)viewController;
- (NSString *)patientViewControllerPatientName:(FTINPatientViewController *)viewController;
- (NSString *)patientViewControllerExaminerName:(FTINPatientViewController *)viewController;
- (NSDate *)patientViewControllerBirthdate:(FTINPatientViewController *)viewController;
- (FTINSex)patientViewControllerSex:(FTINPatientViewController *)viewController;
- (NSString *)patientViewControllerSaveButtonTitle:(FTINPatientViewController *)viewController;
- (BOOL)patientViewControllerShouldShowActivities:(FTINPatientViewController *)viewController;

- (void)patientViewControllerMustSave:(FTINPatientViewController *)viewController withName:(NSString *)name examinerName:(NSString *)examiner birthdate:(NSDate *)birthdate sex:(FTINSex)sex handler:(FTINOperationResult)handler;

@end
