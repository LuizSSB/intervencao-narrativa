//
//  ToastController.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/04/20.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "ToastController.h"
#import "UIView+Toast.h"

NSTimeInterval const ToastDuration = 2.5;

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

- (void)showLocalizedToastText:(NSString *)text withImage:(UIImage *)image
{
	if(self.parentViewController)
	{
		[self.parentViewController showLocalizedToastText:text withImage:image];
	}
	else
	{
		[ToastController showToastText:text.localizedString withImage:image inView:self.view];
	}
}

@end

@implementation ToastController

static CSToastStyle *_style;

+ (void)load
{
	_style = [[CSToastStyle alloc] initWithDefaultStyle];
}

+ (void)showToastText:(NSString *)text inView:(UIView *)view
{
	[view makeToast:text duration:ToastDuration position:CSToastPositionCenter];
}

+ (void)showToastText:(NSString *)text withImage:(UIImage *)image inView:(UIView *)view
{
	_style.imageSize = image.size;
	[view makeToast:text duration:ToastDuration position:CSToastPositionCenter title:[NSString string] image:image style:_style completion:nil];
}

@end
