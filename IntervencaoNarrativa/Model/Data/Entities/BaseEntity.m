//
//  BaseEntity.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/09.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "BaseEntity.h"


@implementation BaseEntity

@dynamic creationDate;

- (void)awakeFromInsert
{
	self.creationDate = [NSDate date];
}

@end
