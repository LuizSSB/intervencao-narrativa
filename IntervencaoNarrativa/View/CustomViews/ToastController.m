//
//  ToastController.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/04/20.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "ToastController.h"
#import "UIView+APToast.h"

NSTimeInterval const ToastDuration = 2.;

@implementation UIViewController (Toast)

- (void)showToastText:(NSString *)text
{
	if(self.parentViewController)
	{
		[self.parentViewController showToastText:text];
	}
	else
	{
		[ToastController showToastText:text inView:self.view];
	}
}

- (void)showLocalizedToastText:(NSString *)text
{
	[self showToastText:text.localizedString];
}

@end

@implementation ToastController

+ (void)showToastText:(NSString *)text inView:(UIView *)view
{
	[view ap_makeToast:text duration:ToastDuration position:APToastPositionCenter];
}

@end
