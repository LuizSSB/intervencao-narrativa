//
//  NSString+LocalizedString.h
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/11.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LocalizedString)

@property (nonatomic, readonly) NSString *localizedString;

- (NSString *)localizedStringInNamespace:(NSString *)nameSpace;

- (NSString *)localizedStringWithParam:(id)param;
- (NSString *)localizedStringWithIntParam:(int)param;

@end
