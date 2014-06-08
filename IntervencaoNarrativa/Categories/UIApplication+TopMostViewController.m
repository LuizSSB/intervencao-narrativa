//
//  UIApplication+TopMostViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/08.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "UIApplication+TopMostViewController.h"

@implementation UIApplication (TopMostViewController)

- (UIViewController*)topMostViewController
{
    UIViewController *topController = self.keyWindow.rootViewController;
	
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
	
    return topController;
}
@end
