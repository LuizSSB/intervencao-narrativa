//
//  UIImage+ImageNamed.m
//  IntervencaoNarrativa
//
//  Created by Luiz SSB on 12/19/15.
//  Copyright © 2015 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "UIImage+ImageNamed.h"

@implementation UIImage (ImageNamed)

+ (UIImage *)lssb_imageNamed:(NSString *)imageName
{
	UIImage *image;
	
	do
	{
		image = [UIImage imageNamed:imageName];
		if(image) return image;
		
		image = [UIImage imageNamed:[imageName stringByAppendingString:@".jpg"]];
		if(image) return image;
		
		image = [UIImage imageNamed:[imageName stringByAppendingString:@".bmp"]];
		if(image) return image;
		
		image = [UIImage imageNamed:[imageName stringByAppendingString:@".gif"]];
		if(image) return image;
		
	}
	while (false);
	
	return nil;
}

@end
