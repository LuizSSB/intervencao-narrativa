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

- (void)activityFlowController:(FTINActivityFlowController *)controller gotNextSubActivity:(FTINSubActivityDetails *)nextSubActivity looped:(BOOL)looped error:(NSError *)error;

- (void)activityFlowController:(FTINActivityFlowController *)controller finishedActivity:(FTINActivityDetails *)details error:(NSError *)error;

- (void)activityFlowController:(FTINActivityFlowController *)controller completedSubActivity:(FTINSubActivityDetails *)details error:(NSError *)error;

- (void)activityFlowController:(FTINActivityFlowController *)controller skippedSubActivitiesOfType:(FTINActivityType)type andDifficultyLevel:(NSInteger)difficultyLevel automatically:(BOOL)automatically error:(NSError *)error;

- (void)activityFlowController:(FTINActivityFlowController *)controller failedSubActivity:(FTINSubActivityDetails *)subActivity error:(NSError *)error;

- (void)activityFlowController:(FTINActivityFlowController *)controller pausedActivity:(FTINActivityDetails *)activity error:(NSError *)error;

- (void)activityFlowController:(FTINActivityFlowController *)controller failedActivity:(FTINActivityDetails *)activity error:(NSError *)error;

- (void)activityFlowController:(FTINActivityFlowController *)controller canceledActivity:(FTINActivityDetails *)activity error:(NSError *)error;

@end

@interface FTINActivityFlowController : NSObject <FTINActivityControllerDelegate>

- (id)initWithActivityInFile:(NSURL *)activityUrl andPatient:(Patient *)patient andDelegate:(id<FTINActivityFlowControllerDelegate>)delegate;
- (id)initWithActivit:(Activity *)activity andDelegate:(id<FTINActivityFlowControllerDelegate>)delegate;

@property (nonatomic, readonly) NSURL *activityUrl;
@property (nonatomic, readonly) FTINActivityDetails *activity;
@property (nonatomic, readonly) Patient *patient;

@property (nonatomic, weak) id<FTINActivityFlowControllerDelegate> delegate;

@property (nonatomic, readonly) FTINSubActivityDetails *currentSubActivity;
@property (nonatomic, readonly) NSUInteger incompleteActivities;

- (void)requestNextSubActivity;

- (FTINSubActivityDetails *)jumpToSubActivityAtIndex:(NSUInteger)activityIndex;
- (void)jumpToSubActivity:(FTINSubActivityDetails *)subActivity;

- (BOOL)viewedInstructionsForActivityType:(FTINActivityType)type;
- (void)setViewedInstructions:(BOOL)viewed forActivityType:(FTINActivityType)type;

- (void)start;
- (void)completeSubActivity:(FTINSubActivityDetails *)subActivity;
- (void)skipLevelOfSubActivity:(FTINSubActivityDetails *)subActivity;
- (void)finish;
- (void)fail;
- (void)pauseInSubActivity:(FTINSubActivityDetails *)subActivity;
- (void)cancel;

@end
