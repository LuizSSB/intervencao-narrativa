//
//  FTINActivityController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/08.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FTINActivityDetails, FTINSubActivityDetails, Patient, Activity;

@interface FTINActivityController : NSObject

- (FTINActivityDetails *)activityDetailsWithContentsOfURL:(NSURL *)fileUrl error:(NSError **)error;

- (void)saveSubActivity:(FTINSubActivityDetails *)subActivity resultHandler:(FTINOperationResult)handler;

- (void)saveActivity:(FTINActivityDetails *)activity forPatient:(Patient *)patient resultHandler:(FTINOperationResult)handler;

- (void)cancelActivity:(FTINActivityDetails *)activity resultHandler:(FTINOperationResult)handler;

- (void)deleteActivity:(Activity *)activity resultHandler:(FTINOperationResult)resultHandler;

@end
