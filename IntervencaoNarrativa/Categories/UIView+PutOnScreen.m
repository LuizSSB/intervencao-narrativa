//
//  UIView+PutOnScreen.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "UIView+PutOnScreen.h"

@implementation UIView (PutOnScreen)

- (void)setLocationInsideSuperview:(BOOL)animated
{
	if(animated)
	{
		[UIView animateWithDuration:.3 animations:^{
			[self setLocationInsideSuperview];
		}];
	}
	else
	{
		[self setLocationInsideSuperview];
	}
}

- (void)setLocationInsideSuperview
{
	CGRect correctFrame = self.frame;
	correctFrame.origin.x = MAX(0, correctFrame.origin.x);
	correctFrame.origin.x = MIN(correctFrame.origin.x, self.superview.frame.size.width - correctFrame.size.width);
	correctFrame.origin.y = MAX(0, correctFrame.origin.y);
	correctFrame.origin.y = MIN(correctFrame.origin.y, self.superview.frame.size.height - correctFrame.size.height);
	self.frame = correctFrame;
}

@end
