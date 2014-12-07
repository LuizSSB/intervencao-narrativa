//
//  FTINReportController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FTINReportController, Activity;

@protocol FTINReportControllerDelegate <NSObject>

- (void)reportController:(FTINReportController *)controller generatedReport:(NSString *)report withError:(NSError *)error;

@end

@interface FTINReportController : NSObject

@property (nonatomic) Activity *activity;
@property (nonatomic, weak) id<FTINReportControllerDelegate> delegate;

- (id)initWithActivity:(Activity *)activity andDelegate:(id<FTINReportControllerDelegate>)delegate;

- (void)processReportType:(FTINActivityType)type;
- (void)processScoreReport;

@end
