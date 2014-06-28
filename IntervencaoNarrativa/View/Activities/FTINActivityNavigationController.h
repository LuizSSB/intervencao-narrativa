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

- (void)activityNavigationController:(FTINActivityNavigationController *)navigationController failed:(NSError *)error;

- (void)activityNavigationControllerPaused:(FTINActivityNavigationController *)navigationController;

@end

@interface FTINActivityNavigationController : UINavigationController <FTINActivityFlowControllerDelegate, FTINActivityViewControllerDelegate>

@property (nonatomic, readonly) NSURL *activityFile;
@property (nonatomic, readonly) Patient *patient;
@property (nonatomic, weak) id<FTINActivityNavigationControllerDelegate, UINavigationControllerDelegate> delegate;

- (instancetype)initWithActivity:(NSURL *)activityFile andPatient:(Patient *)patient andDelegate:(id<FTINActivityNavigationControllerDelegate, UINavigationControllerDelegate>)delegate;

- (instancetype)initWithUnfinishedActivity:(Activity *)activity andDelegate:(id<FTINActivityNavigationControllerDelegate, UINavigationControllerDelegate>)delegate;

@end
