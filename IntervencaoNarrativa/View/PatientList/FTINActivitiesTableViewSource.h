//
//  FTINActivitiesTableViewSource.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/08.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FTINActivitiesTableViewSource, Activity, Patient;

@protocol FTINActivitiesTableViewSourceDelegate <NSObject>

@optional

- (void)activitiesTableViewSource:(FTINActivitiesTableViewSource *)source selectedActivity:(Activity *)activity;

- (void)activitiesTableViewSource:(FTINActivitiesTableViewSource *)source deletedActivity:(Activity *)activity;

@end

@interface FTINActivitiesTableViewSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readonly) Patient *patient;
@property (nonatomic) UITableView *parentTableView;
@property (nonatomic, weak) id<FTINActivitiesTableViewSourceDelegate> delegate;

- (id)initWithPatient:(Patient *)patient andTableView:(UITableView *)parentTableView;

- (void)update;

@end
