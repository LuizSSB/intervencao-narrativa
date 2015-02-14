//
//  UIColor+FromHex.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 1/28/15.
//  Copyright (c) 2015 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FromHex)

+ (UIColor *)colorWithIntRed:(NSInteger)red intGreen:(NSInteger)green intBlue:(NSInteger)blue alpha:(CGFloat)alpha;

@end
