//
//  SubActivity.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/08.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "SubActivity.h"
#import "Activity.h"


@implementation SubActivity

@dynamic creationDate;
@dynamic title;
@dynamic parentActivity;

- (void)awakeFromInsert
{
	self.creationDate = [NSDate date];
}

@end
