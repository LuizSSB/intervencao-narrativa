//
//  EnvironmentSubActivity+Complete.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "EnvironmentSubActivity+Complete.h"

@implementation EnvironmentSubActivity (Complete)

- (FTINCoherence)organizationCoherence
{
	return (FTINCoherence) self.organizationCoherenceNumber.integerValue;
}

- (void)setOrganizationCoherence:(FTINCoherence)organizationCoherence
{
	self.organizationCoherenceNumber = @(organizationCoherence);
}

- (FTINCoherence)narrationCoherence
{
	return (FTINCoherence) self.narrationCoherenceNumber.integerValue;
}

- (void)setNarrationCoherence:(FTINCoherence)narrationCoherence
{
	self.narrationCoherenceNumber = @(narrationCoherence);
}

- (NSSet *)selectedItemsNames
{
    NSMutableSet *itensNames = [NSMutableSet set];
    [self.selectedItems enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [itensNames addObject:[obj name]];
    }];
    return itensNames;
}

- (BOOL)valid:(NSError *__autoreleasing *)error
{
	do
	{
		if(!self.narrationCoherenceNumber) break;
		if(self.narrationCoherenceNumber.integerValue < 0) break;
		if(self.narrationCoherence > FTINCoherenceUnorganized) break;
		
		if(!self.organizationCoherenceNumber) break;
		if(self.organizationCoherenceNumber.integerValue < 0) break;
		if(self.organizationCoherence > FTINCoherenceUnorganized) break;
		
		return YES;
	}
	while (NO);
	
	[NSError ftin_createErrorWithCode:FTINErrorCodePerformanceDataMissing inReference:error];
	return NO;
}

@end
