//
//  FTINActivityViewControllerFactory.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/07.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityViewControllerFactory.h"
#import "FTINSubActivityDetails.h"
#import "FTINActitivitiesFactory.h"

@implementation FTINActivityViewControllerFactory

+ (FTINActivityViewController *)activityViewControllerForSubActivity:(FTINSubActivityDetails *)activity withDelegate:(id<FTINActivityViewControllerDelegate>)delegate
{
	Class viewControllerClass = [FTINActitivitiesFactory classBasedOnSubActivityType:activity.type withSuffix:@"ActivityViewController"];
	FTINActivityViewController *viewController = [[viewControllerClass alloc] initWithSubActivity:activity andDelegate:delegate];
	
	return viewController;
}

@end
