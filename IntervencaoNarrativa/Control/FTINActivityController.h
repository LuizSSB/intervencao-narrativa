//
//  FTINActivityController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/08.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FTINActivityController, FTINActivityDetails, FTINSubActivityDetails, Patient, Activity;

@protocol FTINActivityControllerDelegate <NSObject>

@optional

- (void)activityController:(FTINActivityController *)controller loadedActivity:(FTINActivityDetails *)activity error:(NSError *)error;

- (void)activityController:(FTINActivityController *)controller completedSubActivity:(FTINSubActivityDetails *)subActivity error:(NSError *)error;

- (void)activityController:(FTINActivityController *)controller skippedSubActivity:(FTINSubActivityDetails *)subActivity error:(NSError *)error;

- (void)activityController:(FTINActivityController *)controller failedSubActivity:(FTINSubActivityDetails *)subActivity error:(NSError *)error;

- (void)activityController:(FTINActivityController *)controller finalizedActivity:(FTINActivityDetails *)activity error:(NSError *)error;

- (void)activityController:(FTINActivityController *)controller pausedActivity:(FTINActivityDetails *)activity error:(NSError *)error;

- (void)activityController:(FTINActivityController *)controller failedActivity:(FTINActivityDetails *)activity error:(NSError *)error;

- (void)activityController:(FTINActivityController *)controller canceledActivity:(FTINActivityDetails *)activity error:(NSError *)error;

- (void)activityController:(FTINActivityController *)controller deletedActivity:(Activity *)Activity error:(NSError *)error;

@end

@interface FTINActivityController : NSObject

@property (nonatomic, weak) id<FTINActivityControllerDelegate> delegate;

- (id)initWithDelegate:(id<FTINActivityControllerDelegate>)delegate;

- (void)loadActivityWithContentsOfURL:(NSURL *)fileUrl;

- (void)loadUnfinishedActivity:(Activity *)activity;

- (void)completeSubActivity:(FTINSubActivityDetails *)subActivity;

- (void)skipSubActivity:(FTINSubActivityDetails *)subActivity;

- (void)failSubActivity:(FTINSubActivityDetails *)subActivity;

- (void)finalizeActivity:(FTINActivityDetails *)activity forPatient:(Patient *)patient;

- (void)pauseActivity:(FTINActivityDetails *)activity inSubActivity:(NSInteger)subActivityIndex forPatient:(Patient *)patient;

- (void)failActivity:(FTINActivityDetails *)activity forPatient:(Patient *)patient;

- (void)cancelActivity:(FTINActivityDetails *)activity;

- (void)deleteActivity:(Activity *)activity;

@end
