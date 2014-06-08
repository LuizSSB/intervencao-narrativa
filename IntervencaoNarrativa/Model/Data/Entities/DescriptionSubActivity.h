//
//  DescriptionSubActivity.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/08.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SubActivity.h"


@interface DescriptionSubActivity : SubActivity

@property (nonatomic, retain) id describedElements;
@property (nonatomic, retain) NSNumber * descriptiveSkillInteger;

@end
