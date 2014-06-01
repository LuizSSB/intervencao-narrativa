//
//  FetchRequestDescriptor.h
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/16.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSFetchRequest;

@interface FetchRequestDescriptor : NSObject

@property (nonatomic) NSString *requestName;
@property (nonatomic) NSArray *sortDescriptors;
@property (nonatomic) NSString *predicateFormat;
@property (nonatomic) int limit;

- (NSFetchRequest *)trueFetchRequest;

@end
