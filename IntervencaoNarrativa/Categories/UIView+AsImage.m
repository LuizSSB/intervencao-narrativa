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
    CGFloat scale = [UIScreen mainScreen].scale;
	
    if (scale > 1)
	{
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, scale);
    }
	else
	{
        UIGraphicsBeginImageContext(self.bounds.size);
    }
	
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext: context];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return viewImage;
}

@end
