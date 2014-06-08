//
//  FTINActivityController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/06.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FTINActivityController, FTINActivityDetails, SubActivity, FTINSubActivityDetails;

@protocol FTINActivityControllerDelegate <NSObject>

- (void)activityController:(FTINActivityController *)controller savedActivity:(FTINActivityDetails *)details error:(NSError *)error;

- (void)activityController:(FTINActivityController *)controller savedSubActivity:(FTINSubActivityDetails *)details error:(NSError *)error;

- (void)activityController:(FTINActivityController *)controller canceledActivity:(FTINActivityDetails *)activity error:(NSError *)error;

@end

@interface FTINActivityController : NSObject

- (id)initWithActivityInFile:(NSURL *)activityUrl andPatient:(Patient *)patient andDelegate:(id<FTINActivityControllerDelegate>)delegate;

@property (nonatomic, readonly) NSURL *activityUrl;
@property (nonatomic, readonly) FTINActivityDetails *activity;
@property (nonatomic, readonly) Patient *patient;
@property (nonatomic, weak) id<FTINActivityControllerDelegate> delegate;

@property (nonatomic, readonly) BOOL hasNextSubActivity;
- (FTINSubActivityDetails *)nextSubActivity;

- (BOOL)start:(NSError **)error;
- (void)saveSubActivity:(FTINSubActivityDetails *)subActivity;
- (void)finish;
- (void)cancel;

@end
