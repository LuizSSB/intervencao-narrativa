//
//  FTINSubjectToPatientTransitionNotifications.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Patient;

@protocol FTINSubjectToPatientTransitionNotifications <NSObject>

- (BOOL)allowsEscapeToPatient:(Patient *)patient;
- (BOOL)resonatesWithPatient:(Patient *)patient;

@end
