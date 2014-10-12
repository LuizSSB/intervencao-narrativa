//
//  Acitivity+Complete.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/07.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "Activity.h"

@interface Activity (Complete)

@property (readonly) NSArray *subActivitesInOrder;

- (NSArray *)subActivitiesOfType:(FTINActivityType)type;

@property (nonatomic) BOOL finalized;

@property (nonatomic) NSInteger currentActivityIndex;

@property (nonatomic) SubActivity *currentActivity;

@property (nonatomic) BOOL failed;

@property (nonatomic, readonly) NSURL *baseFileUrl;

@end
