//
//  Acitivity+Complete.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/07.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "Acitivity+Complete.h"

@implementation Activity (Complete)

static NSSortDescriptor *_activitySubActivitesSortDescriptor;

- (NSArray *)subActivitesInOrder
{
	@synchronized([self class])
	{
		if(!_activitySubActivitesSortDescriptor)
		{
			_activitySubActivitesSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(creationDate)) ascending:YES];
		}
	}
	
	NSArray *subs = [self.subActivitites sortedArrayUsingDescriptors:@[_activitySubActivitesSortDescriptor]];
	return subs;
}

@end
