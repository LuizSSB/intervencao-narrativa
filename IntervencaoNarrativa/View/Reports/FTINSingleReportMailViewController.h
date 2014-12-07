//
//  FTINSingleReportMailViewController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINMailComposeViewController.h"

@class Activity;

@interface FTINSingleReportMailViewController : FTINMailComposeViewController

- (id)initWithActivity:(Activity *)activity andView:(UIView *)reportView error:(NSError **)error;

@end
