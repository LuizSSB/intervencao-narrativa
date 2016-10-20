//
//  FTINActivityViewController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/03.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FTINActivityViewController, FTINSubActivityDetails;

@protocol FTINActivityViewControllerDelegate <NSObject>

- (void)activityViewControllerFinished:(FTINActivityViewController *)viewController;

- (void)activityViewControllerCanceled:(FTINActivityViewController *)viewController;

- (void)activityViewControllerSkipped:(FTINActivityViewController *)viewController;

- (void)activityViewControllerPaused:(FTINActivityViewController *)viewController;

- (void)activityViewControllerMustShowActivityList:(FTINActivityViewController *)viewController;

@optional

- (NSArray *)activityViewControllerAdditionalRightBarButtonItems:(FTINActivityViewController *)viewController;

- (UIBarButtonItem *)activityViewControllerCustomizedNextBarButton:(FTINActivityViewController *)viewController;

@end

@interface FTINActivityViewController : FTINBaseViewController <UIAlertViewDelegate>

- (id)initWithSubActivity:(FTINSubActivityDetails *)subactivity andDelegate:(id<FTINActivityViewControllerDelegate>)delegate;

@property (nonatomic, readonly) FTINSubActivityDetails *subActivity;
@property (nonatomic, weak) id<FTINActivityViewControllerDelegate> delegate;

@property (nonatomic, readonly) UIBarButtonItem *cancelBarButton;
@property (nonatomic, readonly) UIBarButtonItem *pauseBarButton;
@property (nonatomic, readonly) UIBarButtonItem *instructionsBarButton;
@property (nonatomic, readonly) UIToolbar *actionToolbar;
@property (nonatomic, readonly) UIBarButtonItem *nextBarButton;
@property (nonatomic, readonly) UIView *titleView;

- (void)cancelActivity:(id)sender;
- (void)goToNextActivity:(id)sender;
- (BOOL)prepareToGoToNextActivity;

- (NSArray *)getActionBarButtons;
- (NSArray *)getNavigationItemRightBarButtons;

- (void)showAnswer;

@end
