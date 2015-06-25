//
//  FTINCollectionViewCell.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/11.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINCollectionViewCell.h"

@interface FTINCollectionViewCell ()

- (void)setupBackgroundView;

@end

@implementation FTINCollectionViewCell

#pragma mark - Super methods

- (void)dealloc
{
	self.backgroundImageView = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupBackgroundView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupBackgroundView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBackgroundView];
    }
    return self;
}

- (void)setupBackgroundView
{
	self.backgroundView = self.backgroundImageView;
}

#pragma mark - Copying

- (id)copyWithZone:(NSZone *)zone
{
	FTINCollectionViewCell *copy = [[FTINCollectionViewCell allocWithZone:zone] initWithFrame:self.frame];
	copy.backgroundImageView.image = self.backgroundImageView.image;
	copy.tag = self.tag;
	
	return copy;
}

#pragma mark - Instance methods

- (UIImageView *)backgroundImageView
{
	if(!_backgroundImageView)
	{
		_backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
		_backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
		_backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_backgroundImageView.clipsToBounds = YES;
	}
	
	return _backgroundImageView;
}

+ (NSString *)cellIdentifier
{
	return NSStringFromClass([self class]);
}

@end
