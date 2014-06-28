//
//  FTINActivityFlowController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/06.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTINActivityController.h"

@class FTINActivityFlowController, FTINActivityDetails, SubActivity, FTINSubActivityDetails;

@protocol FTINActivityFlowControllerDelegate <NSObject>

- (void)activityFlowController:(FTINActivityFlowController *)controller startedWithError:(NSError *)error;

- (void)activityFlowController:(FTINActivityFlowController *)controller savedActivity:(FTINActivityDetails *)details error:(NSError *)error;

- (void)activityFlowController:(FTINActivityFlowController *)controller savedSubActivity:(FTINSubActivityDetails *)details error:(NSError *)error;

- (void)activityFlowController:(FTINActivityFlowController *)controller skippedSubActivity:(FTINSubActivityDetails *)details error:(NSError *)error;

- (void)activityFlowController:(FTINActivityFlowController *)controller pausedActivity:(FTINActivityDetails *)activity error:(NSError *)error;

- (void)activityFlowController:(FTINActivityFlowController *)controller canceledActivity:(FTINActivityDetails *)activity error:(NSError *)error;

@end

@interface FTINActivityFlowController : NSObject <FTINActivityControllerDelegate>

- (id)initWithActivityInFile:(NSURL *)activityUrl andPatient:(Patient *)patient andDelegate:(id<FTINActivityFlowControllerDelegate>)delegate;

@property (nonatomic, readonly) NSURL *activityUrl;
@property (nonatomic, readonly) FTINActivityDetails *activity;
@property (nonatomic, readonly) Patient *patient;
@property (nonatomic, weak) id<FTINActivityFlowControllerDelegate> delegate;

@property (nonatomic, readonly) BOOL started;
@property (nonatomic, readonly) BOOL hasNextSubActivity;
- (FTINSubActivityDetails *)nextSubActivity;

- (void)start;
- (void)startWithUnfinishedActivity:(Activity *)activity;
- (void)saveSubActivity:(FTINSubActivityDetails *)subActivity;
- (void)skipSubActivity:(FTINSubActivityDetails *)subActivity;
- (void)finish;
- (void)pauseInSubActivity:(FTINSubActivityDetails *)subActivity;
- (void)cancel;

@end
