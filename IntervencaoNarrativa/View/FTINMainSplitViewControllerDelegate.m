//
//  FTINMainSplitViewControllerDelegate.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/05/28.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINMainSplitViewControllerDelegate.h"
#import "UISplitViewController+ToggleMasterVisibility.h"

@interface FTINMainSplitViewControllerDelegate ()

@property (nonatomic) UISplitViewController *splitViewController;

@property (nonatomic) UIViewController *masterViewController;
@property (nonatomic, readonly) UIViewController *rootMasterViewController;

@property (nonatomic) UIViewController *detailViewController;
@property (nonatomic, readonly) UIViewController *rootDetailViewController;

@property (nonatomic) UIBarButtonItem *visibilityBarButton;

@end

@implementation FTINMainSplitViewControllerDelegate

static FTINMainSplitViewControllerDelegate *_splitDelegate;

#pragma mark - Super methods

- (void)dealloc
{
	_masterViewController = nil;
	_detailViewController = nil;
	_visibilityBarButton = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
		
		self.splitViewController = (UISplitViewController *)[[UIApplication sharedApplication].delegate window].rootViewController;
		self.splitViewController.presentsWithGesture = NO;
		
		self.masterViewController = self.splitViewController.viewControllers[0];
		self.detailViewController = self.splitViewController.viewControllers[1];
    }
    return self;
}

#pragma mark - Instance methods

+ (void)setup
{
	_splitDelegate = [[FTINMainSplitViewControllerDelegate alloc] init];
	
	UISplitViewController *splitViewController = (UISplitViewController *)[[UIApplication sharedApplication].delegate window].rootViewController;
	splitViewController.delegate = _splitDelegate;
}

+ (UIViewController *)currentDetailViewController
{
	return [[(UINavigationController *)_splitDelegate.detailViewController viewControllers] lastObject];
}

+ (BOOL)masterViewControllerVisible
{
	return _splitDelegate.splitViewController.masterVisible;
}

+ (void)setMasterViewControllerVisible:(BOOL)visible
{
	_splitDelegate.splitViewController.masterVisible = visible;
}

+ (UIBarButtonItem *)barButtonToToggleMasterVisibility
{
	return _splitDelegate.visibilityBarButton;
}

- (UIViewController *)rootMasterViewController
{
	return [(UINavigationController *)self.masterViewController viewControllers][0];
}

- (UIViewController *)rootDetailViewController
{
	return [(UINavigationController *)self.detailViewController viewControllers][0];
}

#pragma mark - Split View Controller Delegate

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
	return YES;
}

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = @"patients".localizedString;
	self.visibilityBarButton = barButtonItem;
    [self.rootDetailViewController.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
	self.visibilityBarButton = nil;
    [self.rootDetailViewController.navigationItem setLeftBarButtonItem:nil animated:YES];
}

@end
