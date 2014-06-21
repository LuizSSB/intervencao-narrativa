//
//  FTINEnumActivityReportFormatter.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTINActivityReportFormatter.h"

@interface FTINEnumActivityReportFormatter : NSObject <FTINActivityReportFormatter>

@property (nonatomic, readonly) NSString *templateResourceName;
@property (nonatomic, readonly) SEL enumKeyPath;

- (void)customizeContext:(NSMutableDictionary *)context;

@end
