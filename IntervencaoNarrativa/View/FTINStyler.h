//
//  FTINStyler.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 1/28/15.
//  Copyright (c) 2015 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTINStyler : NSObject

+ (void)setup;
+ (UIColor *)backgroundColor;
+ (UIColor *)barsTintColor;
+ (UIColor *)cellBackgroundColor;
+ (UIColor *)textColor;
+ (UIColor *)buttonColor;
+ (UIColor *)errorColor;
+ (UIColor *)correctnessColor;
+ (UIColor *)navigationTintColor;

@end
