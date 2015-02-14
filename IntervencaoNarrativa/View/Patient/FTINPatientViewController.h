//
//  FTINPatientViewController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTINPatientViewControllerDelegate.h"
#import "FTINSubjectToPatientTransitionNotifications.h"
#import "FTINActivityNavigationController.h"
#import "FTINActivitiesTableViewSource.h"

@interface FTINPatientViewController : FTINBaseViewController <FTINSubjectToPatientTransitionNotifications, FTINActivitiesTableViewSourceDelegate, FTINActivityNavigationControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) id<FTINPatientViewControllerDelegate> delegate;

@end
