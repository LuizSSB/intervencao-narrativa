//
//  UIView+Border.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/04/03.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "UIView+Border.h"

@implementation UIView (Border)

- (void)setBorder:(UIColor *)color
{
	[self setBorder:color withWidth:1.f];
}

- (void)setBorder:(UIColor *)color withWidth:(float)width
{
	self.layer.borderColor = color.CGColor;
	self.layer.borderWidth = width;
}

- (void)removeBorder
{
	self.layer.borderWidth = 0;
}

@end
