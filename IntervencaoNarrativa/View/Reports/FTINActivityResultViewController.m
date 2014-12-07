//
//  FTINReportSelectionViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityResultViewController.h"
#import "FTINCompleteReportMailViewController.h"
#import "FTINActivityTypeReportViewController.h"
#import "FTINActivityScoreViewController.h"

#import "Activity+Complete.h"

NSString * const FTINSegueReport = @"Report";

NSInteger const FTINActivityResultViewControllerSectionCount = 2;
typedef enum : NSUInteger {
    FTINActivityResultViewControllerSectionReports = 0,
    FTINActivityResultViewControllerSectionActions
} FTINActivityResultViewControllerSection;

NSInteger const FTINActivityResultViewControllerSectionReportsRowCount = 5;
typedef enum : NSUInteger {
    FTINActivityResultViewControllerSectionReportsRowDescription = 0,
    FTINActivityResultViewControllerSectionReportsRowArrangment,
    FTINActivityResultViewControllerSectionReportsRowEnvironment,
    FTINActivityResultViewControllerSectionReportsRowWhyGame,
	FTINActivityResultViewControllerSectionReportsRowTotalScore
} FTINActivityResultViewControllerSectionReportsRow;

NSInteger const FTINActivityResultViewControllerSectionActionsRowCount = 1;
typedef enum : NSUInteger {
    FTINActivityResultViewControllerSectionActionsRowEmail = 0,
} FTINActivityResultViewControllerSectionActionsRow;

@interface FTINActivityResultViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *closeBarButton;
- (IBAction)close:(id)sender;

@end

@implementation FTINActivityResultViewController

#pragma mark - Super methods

- (void)dealloc
{
	_activity = nil;
	self.closeBarButton = nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = self.closeBarButton;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.title = self.activity.title;
}

#pragma mark - Instance methods

+ (UIViewController *)viewControllerWithActivity:(Activity *)activity
{
	FTINActivityResultViewController *viewController = [[FTINActivityResultViewController alloc] init];
	viewController.activity = activity;
	
	UIViewController *parent = [[UINavigationController alloc] initWithRootViewController:viewController];
	parent.modalPresentationStyle = UIModalPresentationFormSheet;
	
	return parent;
}

- (IBAction)close:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return FTINActivityResultViewControllerSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch ((FTINActivityResultViewControllerSection)section)
	{
		case FTINActivityResultViewControllerSectionReports:
			return FTINActivityResultViewControllerSectionReportsRowCount;
			
		case FTINActivityResultViewControllerSectionActions:
			return FTINActivityResultViewControllerSectionActionsRowCount;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [NSStringFromClass(self.class) stringByAppendingFormat:@"_%ld", (long)section].localizedString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FTINDefaultCellIdentifier];
	
	if(!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FTINDefaultCellIdentifier];
	}
	
	cell.textLabel.text = [NSStringFromClass(self.class) stringByAppendingFormat:@"_%ld_%ld", (long)indexPath.section, (long)indexPath.row].localizedString;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	switch (indexPath.section)
	{
		case FTINActivityResultViewControllerSectionActions:
		{
			NSError *error = nil;
			UIViewController *mailVC = [[FTINCompleteReportMailViewController alloc] initWithActivity:self.activity error:&error];
			[NSError alertOnError:error andDoOnSuccess:^{
				[self presentViewController:mailVC animated:YES completion:nil];
			}];
		}
			break;
		
		case FTINActivityResultViewControllerSectionReports:
		{
			
			UIViewController *viewController;
			
			switch ((FTINActivityResultViewControllerSectionReportsRow)indexPath.row) {
				case FTINActivityResultViewControllerSectionReportsRowTotalScore:
					viewController = [FTINActivityScoreViewController viewControllerWithActivity:self.activity];
					break;
					
				default:
					viewController = [FTINActivityTypeReportViewController viewControllerWithActivity:self.activity forType:(FTINActivityType)indexPath.row];
					break;
			}
			
			[self presentViewController:viewController animated:YES completion:nil];
		}
			break;
	}
}

@end
