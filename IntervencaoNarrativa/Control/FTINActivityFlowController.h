//
//  FTINActivityFlowController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/06.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FTINActivityFlowController, FTINActivityDetails, SubActivity, FTINSubActivityDetails;

@protocol FTINActivityFlowControllerDelegate <NSObject>

- (void)activityFlowController:(FTINActivityFlowController *)controller savedActivity:(FTINActivityDetails *)details error:(NSError *)error;

- (void)activityFlowController:(FTINActivityFlowController *)controller savedSubActivity:(FTINSubActivityDetails *)details error:(NSError *)error;

- (void)activityFlowController:(FTINActivityFlowController *)controller canceledActivity:(FTINActivityDetails *)activity error:(NSError *)error;

@end

@interface FTINActivityFlowController : NSObject

- (id)initWithActivityInFile:(NSURL *)activityUrl andPatient:(Patient *)patient andDelegate:(id<FTINActivityFlowControllerDelegate>)delegate;

@property (nonatomic, readonly) NSURL *activityUrl;
@property (nonatomic, readonly) FTINActivityDetails *activity;
@property (nonatomic, readonly) Patient *patient;
@property (nonatomic, weak) id<FTINActivityFlowControllerDelegate> delegate;

@property (nonatomic, readonly) BOOL hasNextSubActivity;
- (FTINSubActivityDetails *)nextSubActivity;

- (BOOL)start:(NSError **)error;
- (void)saveSubActivity:(FTINSubActivityDetails *)subActivity;
- (void)finish;
- (void)cancel;

@end
