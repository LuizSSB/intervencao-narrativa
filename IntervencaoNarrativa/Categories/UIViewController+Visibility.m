//
//  UIViewController+Visibility.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/29.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "UIViewController+Visibility.h"

@implementation UIViewController (Visibility)

- (BOOL)visible
{
	return self.view && self.view.window;
}

- (BOOL)mainViewVisible
{
	return self.visible && !self.view.hidden && self.view.layer.opacity;
}

@end
