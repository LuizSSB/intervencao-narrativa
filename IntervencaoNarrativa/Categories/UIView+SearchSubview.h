//
//  UIView+SearchSubview.h
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/04/06.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SearchSubview)

- (UIView *)firstSubviewOfClass:(Class)klass;

- (UIView *)firstSubviewOfClassNamed:(NSString *)className;

@end
