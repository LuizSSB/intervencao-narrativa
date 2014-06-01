//
//  UITableView+ScrollToBottom.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/05/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "UITableView+ScrollToBottom.h"

@implementation UITableView (ScrollToBottom)

- (void)scrollToBottom
{
	[self scrollRectToVisible:CGRectMake(0, self.contentSize.height - self.bounds.size.height, self.bounds.size.width, self.bounds.size.height) animated:YES];
}

@end
