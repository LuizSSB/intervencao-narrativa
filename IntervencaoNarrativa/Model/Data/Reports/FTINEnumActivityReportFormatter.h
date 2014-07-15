//
//  FTINEnumActivityReportFormatter.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTINActivityReportFormatter.h"

extern NSString * const FTINHTMLClassExecuted;
extern NSString * const FTINHTMLClassSkipped;
extern NSString * const FTINTemplateKeyElementClass;
extern NSString * const FTINTemplateKeyElementValue;
extern NSString * const FTINTemplateKeyElementOptionFormat;

@interface FTINEnumActivityReportFormatter : NSObject <FTINActivityReportFormatter>

@property (nonatomic, readonly) NSString *templateResourceName;
@property (nonatomic, readonly) SEL enumKeyPath;
@property (nonatomic, readonly) NSArray *enumOptions;

- (void)customizeContext:(NSMutableDictionary *)context;

@end
