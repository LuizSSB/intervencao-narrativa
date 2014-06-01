//
//  ToastController.h
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/04/20.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (Toast)

- (void)showToastText:(NSString *)text;
- (void)showLocalizedToastText:(NSString *)text;

@end

@interface ToastController : NSObject

+ (void)showToastText:(NSString *)text inView:(UIView *)view;

@end
