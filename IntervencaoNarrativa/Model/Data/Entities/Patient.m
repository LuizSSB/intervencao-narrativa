//
//  Patient.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/08.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "Patient.h"
#import "Activity.h"


@implementation Patient

@dynamic birthdate;
@dynamic creationDate;
@dynamic examiner;
@dynamic name;
@dynamic sexInteger;
@dynamic activities;

- (void)awakeFromInsert
{
	self.creationDate = [NSDate date];
}

+ (NSString *)primaryKey
{
	return NSStringFromSelector(@selector(name));
}

@end
