//
//  FTINActivityViewControllerFactory.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/07.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTINActivityViewController.h"

@class FTINSubActivityDetails;

@interface FTINActivityViewControllerFactory : NSObject

+ (FTINActivityViewController *)activityViewControllerForSubActivity:(FTINSubActivityDetails *)activity withDelegate:(id<FTINActivityViewControllerDelegate>)delegate;

@end
