//
//  FTINActivityViewController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/03.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTINActivityViewController : UIViewController

@property (nonatomic, readonly) UIBarButtonItem *cancelButton;
@property (nonatomic, readonly) UIToolbar *actionToolbar;
@property (nonatomic, readonly) UIBarButtonItem *nextButton;

- (void)cancelActivity:(id)sender;
- (void)goToNextActivity:(id)sender;

- (NSArray *)getActionBarButtons;

@end
