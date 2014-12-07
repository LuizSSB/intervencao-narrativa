//
//  UIView+AsImage.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "UIView+AsImage.h"

@implementation UIView (AsImage)

- (UIImage *)asImage
{
	CGRect originalBounds = self.bounds;
	
	if([self isKindOfClass:[UIScrollView class]])
	{
		CGRect newBounds = originalBounds;
		newBounds.size = [(id)self contentSize];
		self.bounds = newBounds;
	}
	
    CGFloat scale = [UIScreen mainScreen].scale;
	
    if (scale > 1)
	{
        UIGraphicsBeginImageContextWithOptions(self.layer.bounds.size, NO, scale);
    }
	else
	{
        UIGraphicsBeginImageContext(self.layer.bounds.size);
    }
	
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	self.bounds = originalBounds;
	
    return viewImage;
}

@end
