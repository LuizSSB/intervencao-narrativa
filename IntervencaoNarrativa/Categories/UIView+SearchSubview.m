//
//  UIView+SearchSubview.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/04/06.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "UIView+SearchSubview.h"

@implementation UIView (SearchSubview)

- (UIView *)firstSubviewOfClass:(Class)klass
{
	for (UIView *subview in self.subviews)
	{
		if([subview isKindOfClass:klass])
		{
			return subview;
		}
		else
		{
			UIView *subviewsubview = [subview firstSubviewOfClass:klass];
			
			if(subviewsubview)
			{
				return subviewsubview;
			}
		}
	}
	
	return nil;
}

- (UIView *)firstSubviewOfClassNamed:(NSString *)className
{
	return [self firstSubviewOfClass:NSClassFromString(className)];
}

@end
