//
//  Patient+Sex.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/05.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "Patient+Complete.h"

@implementation Patient (Sex)

- (FTINSex)sex
{
	return (FTINSex) self.sexNumber.integerValue;
}

- (void)setSex:(FTINSex)sex
{
	self.sexNumber = @(sex);
}

static NSSortDescriptor *_patientActivitiesSortDescriptor;

- (NSArray *)activitiesInOrder
{
	@synchronized([self class])
	{
		if(!_patientActivitiesSortDescriptor)
		{
			_patientActivitiesSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(creationDate)) ascending:YES];
		}
	}
	
	NSArray *ordered = [self.activities sortedArrayUsingDescriptors:@[_patientActivitiesSortDescriptor]];
	return ordered;
}


@end
