//
//  FTINMainSplitViewControllerDelegate.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/05/28.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINMainSplitViewControllerDelegate.h"

@interface FTINMainSplitViewControllerDelegate ()
{
	UIViewController *_rootDetailViewController;
}

@end

@implementation FTINMainSplitViewControllerDelegate

static FTINMainSplitViewControllerDelegate *_mainSplitViewControllerDelegate;

#pragma mark - Super methods

- (void)dealloc
{
	_rootDetailViewController = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
		
		UISplitViewController *splitViewController = (UISplitViewController *)[[UIApplication sharedApplication].delegate window].rootViewController;
        _rootDetailViewController = [[splitViewController.viewControllers lastObject] viewControllers][0];
    }
    return self;
}

#pragma mark - Instance methods

+ (void)setup
{
	_mainSplitViewControllerDelegate = [[FTINMainSplitViewControllerDelegate alloc] init];
	
	UISplitViewController *splitViewController = (UISplitViewController *)[[UIApplication sharedApplication].delegate window].rootViewController;
	splitViewController.delegate = _mainSplitViewControllerDelegate;
}

#pragma mark - Split View Controller Delegate

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
	return YES;
}

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"patients", @"");
    [_rootDetailViewController.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [_rootDetailViewController.navigationItem setLeftBarButtonItem:nil animated:YES];
}

@end
