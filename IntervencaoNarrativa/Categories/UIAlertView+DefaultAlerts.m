//
//  UIAlertView+DefaultAlerts.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "UIAlertView+DefaultAlerts.h"

@implementation UIAlertView (DefaultAlerts)

+ (UIAlertView *)alertViewWithError:(NSString *)errorMessage
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error".localizedString message:errorMessage delegate:nil cancelButtonTitle:@"cancel".localizedString otherButtonTitles:nil];
	return alert;
}

+ (UIAlertView *)alertViewWithWarning:(NSString *)errorMessage
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"warning".localizedString message:errorMessage delegate:nil cancelButtonTitle:@"cancel".localizedString otherButtonTitles:nil];
	return alert;
}

@end
