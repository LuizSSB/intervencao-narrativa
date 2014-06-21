//
//  FTINActivityReportFormatter.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FTINActivityReportFormatter <NSObject>

- (NSString *)formatActivities:(NSArray *)activities error:(NSError **)error;

@end
