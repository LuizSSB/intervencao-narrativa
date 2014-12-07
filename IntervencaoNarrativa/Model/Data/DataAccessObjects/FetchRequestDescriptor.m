//
//  FetchRequestDescriptor.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/16.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FetchRequestDescriptor.h"
#import "DataManager.h"
#import <CoreData/CoreData.h>

@implementation FetchRequestDescriptor

- (NSFetchRequest *)trueFetchRequest
{
	NSFetchRequest *requestTemplate = [[NSFetchRequest alloc] init];
	
	if(self.predicateFormat && self.predicateFormat.length)
	{
		[requestTemplate setPredicate:[NSPredicate predicateWithFormat:self.predicateFormat argumentArray:nil]];
	}
	
	if(self.limit > 0)
	{
		[requestTemplate setFetchLimit:self.limit];
	}
	
	if(self.sortDescriptors && self.sortDescriptors.count)
	{
		[requestTemplate setSortDescriptors:self.sortDescriptors];
	}
	
	return requestTemplate;
}

@end
