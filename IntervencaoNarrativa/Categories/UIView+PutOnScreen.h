//
//  UIView+PutOnScreen.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PutOnScreen)

- (void)setLocationInsideSuperview:(BOOL)animated;
- (void)setLocationInsideSuperview;

@end
