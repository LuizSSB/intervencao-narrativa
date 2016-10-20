//
//  FTINQuickGuideViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz SSB on 5/31/16.
//  Copyright © 2016 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINQuickGuideViewController.h"

@interface FTINQuickGuideViewController () <UIScrollViewDelegate>
{
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
- (IBAction)close:(id)sender;

- (NSAttributedString *)stylizeText:(NSString *)string;

@end

@implementation FTINQuickGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [FTINStyler backgroundColor];
	
	self.scrollView.contentSize = CGSizeMake(
											 self.pageControl.numberOfPages * self.scrollView.frame.size.width,
											 self.scrollView.frame.size.height
											 );
	
	self.titleLabel.textColor = [FTINStyler barsTintColor];
	
	CGRect frame = CGRectZero;
	frame.size = self.scrollView.frame.size;
	for (NSInteger idx = 0; idx < 6; ++idx) {
		frame.origin.x = idx *frame.size.width;
		
		NSString *imgName = [NSString stringWithFormat:@"guide_img_%ld", (long)idx].localizedString;
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage lssb_imageNamed:imgName]];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.frame = frame;
		[self.scrollView addSubview:imageView];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self setPage:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

	for (UIView *view in self.scrollView.subviews) {
		[view removeFromSuperview];
	}
}

- (IBAction)close:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setPage:(NSInteger)page
{
	self.pageControl.currentPage = page;
	NSString *newTitle = [@"guide_title_" stringByAppendingFormat:@"%ld", (long)page].localizedString;
	NSString *newText = [@"guide_text_" stringByAppendingFormat:@"%ld", (long)page].localizedString;
	NSAttributedString *attributedNewText = [self stylizeText:newText];
	
	[UIView animateWithDuration:FTINDefaultAnimationDuration/2. animations:^{
		self.titleLabel.layer.opacity = self.textLabel.layer.opacity = 0.;
	} completion:^(BOOL finished) {
		self.titleLabel.text = newTitle;
		self.textLabel.attributedText = attributedNewText;
		[UIView animateWithDuration:FTINDefaultAnimationDuration/2. animations:^{
			self.titleLabel.layer.opacity = self.textLabel.layer.opacity = 1.;
			[self.textLabel setNeedsDisplay];
		}];
	}];
}

- (NSAttributedString *)stylizeText:(NSString *)string
{
	NSInteger strIdx = 0;
	NSArray *parts = [string componentsSeparatedByString:@"*"];
	string = [string stringByReplacingOccurrencesOfString:@"*" withString:[NSString string]];
	NSMutableAttributedString *styledText = [[NSMutableAttributedString alloc] initWithString:string];
	
	for (NSInteger idx = 0; idx < parts.count; ++idx)
	{
		NSInteger partLength = [parts[idx] length];
		
		if (idx % 2) // Closes styling
		{
			NSRange styleRange = NSMakeRange(strIdx, partLength);
			[styledText addAttributes:@{NSForegroundColorAttributeName:[FTINStyler buttonColor]}
								range:styleRange];
		}
		
		strIdx += partLength;
	}
	
	return styledText;
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat x = scrollView.contentOffset.x / scrollView.frame.size.width;
	BOOL decimalPartAddsOne = (x - floor(x)) > .5;
	NSInteger page = x + decimalPartAddsOne;
	
	if (page != self.pageControl.currentPage)
	{
		[self setPage:page];
	}
	scrollView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	scrollView.userInteractionEnabled = YES;
}

@end
