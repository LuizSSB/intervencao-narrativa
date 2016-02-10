//
//  FTINQuestionCardBackCollectionViewCell.m
//  IntervencaoNarrativa
//
//  Created by Luiz SSB on 6/24/15.
//  Copyright (c) 2015 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINQuestionCardBackCollectionViewCell.h"

@interface FTINQuestionCardBackCollectionViewCell ()

@property (nonatomic) IBOutlet UILabel *answeredLabel;

- (void)setup;

@end

@implementation FTINQuestionCardBackCollectionViewCell

- (void)dealloc
{
	self.answeredLabel = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setup];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self setup];
	}
	return self;
}

- (void)setup
{
	UIFont *font = [UIFont systemFontOfSize:17.0];
	CGFloat height = font.lineHeight + 2 * 8;
	CGRect frame = CGRectMake(0, self.frame.size.height - height, self.frame.size.width, height);
	self.answeredLabel = [[UILabel alloc] initWithFrame:frame];
	self.answeredLabel.textColor = [UIColor darkGrayColor];
	self.answeredLabel.font = font;
	self.answeredLabel.textAlignment = NSTextAlignmentCenter;
	self.answeredLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	self.answeredLabel.text = @"answered".localizedString;
	[self addSubview:self.answeredLabel];
	
	self.backgroundImageView.image = [UIImage lssb_imageNamed:@"cardback"];
}

- (BOOL)answered
{
	return !self.answeredLabel.hidden;
}

- (void)setAnswered:(BOOL)answered
{
	self.answeredLabel.hidden = !answered;
}

@end
