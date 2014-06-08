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
	return (FTINSex) self.sexInteger.integerValue;
}

- (void)setSex:(FTINSex)sex
{
	self.sexInteger = @(sex);
}

@end
