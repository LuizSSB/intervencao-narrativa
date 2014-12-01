//
//  FTINActivityReportViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityReportViewController.h"
#import "FTINSingleReportMailViewController.h"
#import "Activity+Complete.h"

@interface FTINActivityReportViewController () <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *closeBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *actionBarButton;

- (IBAction)close:(id)sender;
- (IBAction)doAction:(id)sender;

@end

@implementation FTINActivityReportViewController

#pragma mark - Super methods

- (void)dealloc
{
	_activity = nil;
	self.closeBarButton = nil;
	self.actionBarButton = nil;
}

- (instancetype)init
{
	self = [super initWithNibName:NSStringFromClass([FTINActivityReportViewController class]) bundle:[NSBundle mainBundle]];
	if (self) {
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationController.navigationBar.translucent = NO;
	self.contentWebView.frame = self.view.bounds;	
	self.title = [self.activity.title stringByAppendingFormat:@" - %@", @"report".localizedString];
	
	self.navigationItem.leftBarButtonItem = self.closeBarButton;
	self.navigationItem.rightBarButtonItem = self.actionBarButton;
}

#pragma mark - Instance methods

- (IBAction)close:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doAction:(id)sender
{
	NSError *error = nil;
	UIViewController *mailVC = [[FTINSingleReportMailViewController alloc] initWithActivity:self.activity andView:self.contentWebView error:&error];
	[NSError alertOnError:error andDoOnSuccess:^{
		[self presentViewController:mailVC animated:YES completion:nil];
	}];
}

@end
