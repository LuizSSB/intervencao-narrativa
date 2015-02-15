//
//  FTINSubActivitiesTableViewController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/07/02.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FTINSubActivitiesTableViewController, FTINSubActivityDetails, FTINActivityDetails;

@protocol FTINSubActivitiesTableViewControllerDelegate <NSObject>

- (BOOL)subActivitesViewController:(FTINSubActivitiesTableViewController *)viewController shouldMarkSubActivity:(FTINSubActivityDetails *)subActivity atIndex:(NSUInteger)index;

- (void)subActivitiesViewController:(FTINSubActivitiesTableViewController *)viewController selectedSubActivity:(FTINSubActivityDetails *)subActivity atIndex:(NSUInteger)index;

@end

@interface FTINSubActivitiesTableViewController : FTINBaseTableViewController

@property (nonatomic) FTINActivityDetails *activity;
@property (nonatomic, weak) id<FTINSubActivitiesTableViewControllerDelegate> delegate;

- (id)initWithActivity:(FTINActivityDetails *)activity andDelegate:(id<FTINSubActivitiesTableViewControllerDelegate>)delegate;

- (void)presentAsPopoverFromBarButtonItem:(UIBarButtonItem *)button animated:(BOOL)animated;
- (void)dismissPopoverAnimated:(BOOL)animated;

@end
