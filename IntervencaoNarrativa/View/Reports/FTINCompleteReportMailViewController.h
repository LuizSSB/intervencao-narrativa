//
//  FTINCompleteReportMailViewController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTINMailComposeViewController.h"

@class Activity;

@interface FTINCompleteReportMailViewController : FTINMailComposeViewController

- (id)initWithActivity:(Activity *)activity error:(NSError **)error;

@end
