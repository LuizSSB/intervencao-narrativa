//
//  UIAlertView+DefaultAlerts.h
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (DefaultAlerts)

+ (UIAlertView *)alertViewWithError:(NSString *)errorMessage;
+ (UIAlertView *)alertViewWithWarning:(NSString *)errorMessage;

@end
