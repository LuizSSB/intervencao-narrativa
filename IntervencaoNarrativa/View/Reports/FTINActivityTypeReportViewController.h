//
//  FTINActivityTypeReportViewController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 12/1/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityReportViewController.h"

@interface FTINActivityTypeReportViewController : FTINActivityReportViewController

+ (UIViewController *)viewControllerWithActivity:(Activity *)activity forType:(FTINActivityType)type;

@property (nonatomic) FTINActivityType reportType;

@end
