//
//  FTINExistingPatientViewControllerDelegate.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTINPatientViewControllerDelegate.h"
#import "FTINPatientController.h"

@interface FTINExistingPatientViewControllerDelegate : NSObject <FTINPatientViewControllerDelegate, FTINPatientControllerDelegate>

@property (nonatomic) Patient *patient;

- (id)initWithPatient:(Patient *)patient;

@end
