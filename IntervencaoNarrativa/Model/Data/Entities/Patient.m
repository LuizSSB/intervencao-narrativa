//
//  Patient.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "Patient.h"
#import "DCModel.h"

@implementation Patient

@dynamic creationDate;
@dynamic name;
@dynamic examiner;
@dynamic sexInteger;
@dynamic birthdate;

- (FTINSex)sex
{
	return (FTINSex)self.sexInteger.unsignedIntegerValue;
}

- (void)setSex:(FTINSex)sex
{
	self.sexInteger = @(sex);
}

+ (NSString *)primaryKey
{
	return NSStringFromSelector(@selector(name));
}

@end
