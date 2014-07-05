//
//  EnvironmentSubActivity.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SubActivity+Complete.h"


@interface EnvironmentSubActivity : SubActivity

@property (nonatomic, retain) NSSet * selectedItems;
@property (nonatomic, retain) NSNumber * organizationCoherenceNumber;
@property (nonatomic, retain) NSNumber * narrationCoherenceNumber;

@end
