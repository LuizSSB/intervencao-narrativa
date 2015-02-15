//
//  UIColor+FromHex.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 1/28/15.
//  Copyright (c) 2015 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "UIColor+FromHex.h"

@implementation UIColor (FromHex)

+ (UIColor *)colorWithIntRed:(NSInteger)red intGreen:(NSInteger)green intBlue:(NSInteger)blue alpha:(CGFloat)alpha
{
	return [UIColor colorWithRed:((CGFloat)red)/255.f
						   green:((CGFloat)green/255.f)
							blue:((CGFloat)blue/255.f)
						   alpha:alpha];
}

@end
