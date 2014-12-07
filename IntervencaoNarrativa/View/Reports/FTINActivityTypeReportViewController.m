//
//  FTINActivityTypeReportViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 12/1/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityTypeReportViewController.h"
#import "FTINReportController.h"
#import "MBProgressHUD.h"
#import "Activity+Complete.h"

@interface FTINActivityTypeReportViewController ()<FTINReportControllerDelegate, UIWebViewDelegate>

@property (nonatomic, readonly) FTINReportController *controller;

@end

@implementation FTINActivityTypeReportViewController

- (void)dealloc
{
	_controller = nil;
}

#pragma mark - Super Methods

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[self.controller processReportType:self.reportType];
}

#pragma mark - Instance methods

+ (UIViewController *)viewControllerWithActivity:(Activity *)activity forType:(FTINActivityType)type
{
	FTINActivityTypeReportViewController *viewController = [[FTINActivityTypeReportViewController alloc] init];
	viewController.activity = activity;
	viewController.reportType = type;
	
	return [[UINavigationController alloc] initWithRootViewController:viewController];
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

#pragma mark - Report Controller Delegate

- (void)reportController:(FTINReportController *)controller generatedReport:(NSString *)report withError:(NSError *)error
{
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	
	[NSError alertOnError:error andDoOnSuccess:^{
		[self.contentWebView loadHTMLString:report baseURL:[NSBundle mainBundle].bundleURL];
	}];
}


@end
