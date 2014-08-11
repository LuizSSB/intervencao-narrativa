//
//  FTINReportFormatter.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Activity;

@interface FTINReportFormatter : NSObject

@property (nonatomic) Activity *activity;

- (id)initWithActivity:(Activity *)activity;

- (NSString *)createReportActivitiesOfType:(FTINActivityType)type error:(NSError **)error;

@end
