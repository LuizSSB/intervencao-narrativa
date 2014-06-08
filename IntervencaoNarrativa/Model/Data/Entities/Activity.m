//
//  Activity.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/08.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "Activity.h"
#import "Patient.h"
#import "SubActivity.h"


@implementation Activity

@dynamic creationDate;
@dynamic finalized;
@dynamic title;
@dynamic patient;
@dynamic subActivities;

- (void)awakeFromInsert
{
	self.creationDate = [NSDate date];
}

@end
