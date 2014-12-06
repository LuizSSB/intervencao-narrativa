//
//  FTINActivityScoreViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 12/1/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityScoreViewController.h"
#import "FTINReportController.h"
#import "MBProgressHUD.h"

@interface FTINActivityScoreViewController ()<FTINReportControllerDelegate>


@property (nonatomic, readonly) FTINReportController *controller;

@end

@implementation FTINActivityScoreViewController

#pragma mark - Super methods

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[self.controller processScoreReport];
}

#pragma mark - Instance methods

+ (UIViewController *)viewControllerWithActivity:(Activity *)activity
{
	FTINActivityScoreViewController *viewController = [[FTINActivityScoreViewController alloc] init];
	viewController.activity = activity;
	
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
