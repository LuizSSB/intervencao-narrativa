//
//  UIDevice+SystemVersion.h
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/11.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (SystemVersion)

@property (nonatomic, readonly) BOOL deviceIsPhone;
@property (nonatomic, readonly) BOOL deviceIsPhone5;
@property (nonatomic, readonly) BOOL deviceIsPad;
@property (nonatomic, readonly) BOOL systemUsesVersion7Design;

- (BOOL)systemMainVersionGreaterThan:(int)systemMainVersion;
- (BOOL)systemMainVersionLessThan:(int)systemMainVersion;
- (BOOL)systemMainVersionGreaterThanOrEqualTo:(int)systemMainVersion;
- (BOOL)systemMainVersionLessThanOrEqualTo:(int)systemMainVersion;
- (BOOL)systemMainVersionEqualTo:(int)systemMainVersion;

- (BOOL)systemVersionGreaterThan:(NSString *)version;
- (BOOL)systemVersionLessThan:(NSString *)version;
- (BOOL)systemVersionGreaterThanOrEqualTo:(NSString *)version;
- (BOOL)systemVersionLessThanOrEqualTo:(NSString *)version;
- (BOOL)systemVersionEqualTo:(NSString *)version;

@end
