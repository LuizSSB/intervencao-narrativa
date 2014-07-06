//
//  DescriptionSubActivity.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/10.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SubActivity+Complete.h"


@interface DescriptionSubActivity : SubActivity

@property (nonatomic, retain) NSSet * describedElements;
@property (nonatomic, retain) NSNumber * descriptiveSkillNumber;

@end
