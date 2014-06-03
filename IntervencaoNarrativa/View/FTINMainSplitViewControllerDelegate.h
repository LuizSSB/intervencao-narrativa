//
//  FTINMainSplitViewControllerDelegate.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/05/28.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTINMainSplitViewControllerDelegate : NSObject <UISplitViewControllerDelegate>

+ (void)setup;

+ (UIViewController *)currentDetailViewController;

+ (BOOL)masterViewControllerVisible;
+ (void)setMasterViewControllerVisible:(BOOL)visible;

+ (UIBarButtonItem *)barButtonToToggleMasterVisibility;

@end
