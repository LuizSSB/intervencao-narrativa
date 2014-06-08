//
//  FTINActivityNavigationController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/07.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTINActivityFlowController.h"
#import "FTINActivityViewController.h"

@class FTINActivityNavigationController, Patient;

@protocol FTINActivityNavigationControllerDelegate <NSObject>

- (void)activityNavigationControllerFinished:(FTINActivityNavigationController *)navigationController;

- (void)activityNavigationControllerCanceled:(FTINActivityNavigationController *)navigationController;

- (void)activityNavigationController:(FTINActivityNavigationController *)navigationController failedToLoadBecauseOfError:(NSError *)error;

@end

@interface FTINActivityNavigationController : UINavigationController <FTINActivityFlowControllerDelegate, FTINActivityViewControllerDelegate>

@property (nonatomic, readonly) NSURL *activityFile;
@property (nonatomic, readonly) Patient *patient;
@property (nonatomic, weak) id<FTINActivityNavigationControllerDelegate, UINavigationControllerDelegate> delegate;

- (id)initWithActivity:(NSURL *)activityFile andPatient:(Patient *)patient error:(NSError **)error;

@end
