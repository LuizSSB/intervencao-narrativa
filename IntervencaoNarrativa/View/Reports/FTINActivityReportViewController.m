//
//  FTINActivityReportViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityReportViewController.h"
#import "FTINReportController.h"
#import "FTINSingleReportMailViewController.h"
#import "MBProgressHUD.h"

#import "Activity+Complete.h"

@interface FTINActivityReportViewController () <FTINReportControllerDelegate, UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *closeBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *actionBarButton;
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;

- (IBAction)close:(id)sender;
- (IBAction)doAction:(id)sender;

@property (nonatomic, readonly) FTINReportController *controller;
@property (nonatomic, readonly) NSURL *baseUrl;

@end

@implementation FTINActivityReportViewController

#pragma mark - Super methods

- (void)dealloc
{
	_activity = nil;
	_controller = nil;
	self.closeBarButton = nil;
	self.actionBarButton = nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = [self.activity.title stringByAppendingFormat:@" - %@", @"report".localizedString];
	
	self.navigationItem.leftBarButtonItem = self.closeBarButton;
	self.navigationItem.rightBarButtonItem = self.actionBarButton;
	
	self.contentWebView.scrollView.scrollEnabled = NO;
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[self.controller processReportType:self.reportType];
}

#pragma mark - Instance methods

+ (UIViewController *)viewControllerWithActivity:(Activity *)activity forType:(FTINActivityType)type
{
	FTINActivityReportViewController *viewController = [[FTINActivityReportViewController alloc] init];
	viewController.activity = activity;
	viewController.reportType = type;
	
	return [[UINavigationController alloc] initWithRootViewController:viewController];
}

- (IBAction)close:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doAction:(id)sender
{
	NSError *error = nil;
	UIViewController *mailVC = [[FTINSingleReportMailViewController alloc] initWithActivity:self.activity andView:self.contentWebView error:&error];	[NSError alertOnError:error andDoOnSuccess:^{
		[self presentViewController:mailVC animated:YES completion:nil];
	}];
}

@synthesize controller = _controller;

- (FTINReportController *)controller
{
	if(!_controller)
	{
		_controller = [[FTINReportController alloc] initWithActivity:self.activity andDelegate:self];
	}
	
	return _controller;
}

@synthesize baseUrl = _baseUrl;

- (NSURL *)baseUrl
{
	if(!_baseUrl)
	{
		_baseUrl = [NSBundle mainBundle].bundleURL;
	}
	
	return _baseUrl;
}

#pragma mark - Report Controller Delegate

- (void)reportController:(FTINReportController *)controller generatedReport:(NSString *)report withError:(NSError *)error
{
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	
	[NSError alertOnError:error andDoOnSuccess:^{
		[self.contentWebView loadHTMLString:report baseURL:self.baseUrl];
	}];
}

@end
