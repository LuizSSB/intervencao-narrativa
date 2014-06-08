//
//  DescriptionSubActivity.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/08.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "DescriptionSubActivity.h"


@implementation DescriptionSubActivity

@dynamic describedElements;
@dynamic descriptiveSkillInteger;

- (void)awakeFromInsert
{
	[super awakeFromInsert];
	self.descriptiveSkillInteger = nil;
}

@end
