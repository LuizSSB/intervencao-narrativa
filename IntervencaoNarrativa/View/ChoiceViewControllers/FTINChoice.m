//
//  FTINChoice.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/04.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINChoice.h"

@implementation FTINChoice

#pragma mark - Super methods

- (void)dealloc
{
	_title = nil;
	_image = nil;
}

#pragma mark - Instance methods

+ (FTINChoice *)choiceWithTitle:(NSString *)title andImage:(UIImage *)image
{
	return [[self alloc] initWithTitle:title andImage:image];
}

- (instancetype)initWithTitle:(NSString *)title andImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.title = title;
		self.image = image;
    }
    return self;
}

@end
