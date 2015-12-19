//
//  FTINStyler.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 1/28/15.
//  Copyright (c) 2015 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINStyler.h"

@implementation FTINStyler

+ (void)setup
{
	[UITableViewCell appearance].backgroundColor = [FTINStyler cellBackgroundColor];
	[UINavigationBar appearance].barTintColor =	[UIToolbar appearance].barTintColor = [UISearchBar appearance].barTintColor = [FTINStyler barsTintColor];
	[UINavigationBar appearance].tintColor = [UIToolbar appearance].tintColor = [UISearchBar appearance].tintColor = [UIColor whiteColor];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UINavigationBar appearance].tintColor}];
	[UILabel appearance].textColor = [UITextView appearance].textColor = [FTINStyler textColor];
	[UIButton appearance].tintColor = [UISegmentedControl appearance].tintColor = [FTINStyler buttonColor];
	
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

+ (UIColor *)backgroundColor
{
	static UIColor *backgroundColor = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		backgroundColor = [UIColor colorWithPatternImage:[UIImage lssb_imageNamed:@"bg"]];
	});
	return backgroundColor;
}

+ (UIColor *)barsTintColor
{
	return [UIColor colorWithIntRed:128 intGreen:182 intBlue:227 alpha:1.0];
}

+ (UIColor *)cellBackgroundColor
{
	return [UIColor colorWithIntRed:237 intGreen:248 intBlue:254 alpha:1.0];
}

+ (UIColor *)textColor
{
	return [UIColor colorWithIntRed:96 intGreen:96 intBlue:97 alpha:1.0];
}

+ (UIColor *)buttonColor
{
	return [UIColor colorWithIntRed:248 intGreen:161 intBlue:103 alpha:1.0];
}

+ (UIColor *)errorColor
{
	return [UIColor colorWithIntRed:246 intGreen:159 intBlue:153 alpha:1.0];
}

+ (UIColor *)correctnessColor
{
	return [FTINStyler barsTintColor];
}

@end
