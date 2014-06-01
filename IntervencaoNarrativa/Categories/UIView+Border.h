//
//  UIView+Border.h
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/04/03.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Border)

- (void)setBorder:(UIColor *)color;
- (void)setBorder:(UIColor *)color withWidth:(float)width;
- (void)removeBorder;

@end
