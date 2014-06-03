//
//  UISplitViewController+ToggleMasterVisibility.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/02.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "UISplitViewController+ToggleMasterVisibility.h"

@implementation UISplitViewController (ToggleMasterVisibility)

- (BOOL)masterVisible
{
	return [self.viewControllers[0] view].frame.origin.x >= 0;
}

- (void)setMasterVisible:(BOOL)masterVisible
{
	if(masterVisible != self.masterVisible)
	{
		SEL toggleSelector = NSSelectorFromString(@"toggleMasterVisible:");
		
		if([self respondsToSelector:toggleSelector])
		{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
			[self performSelector:toggleSelector];
#pragma clang diagnostic pop
		}
	}
}

@end
