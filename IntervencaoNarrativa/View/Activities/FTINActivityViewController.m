//
//  FTINActivityViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/03.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityViewController.h"
#import "FTINSubActivityDetails.h"
#import "FTINSubActivityContent.h"

#import "SubActivity+Complete.h"

NSInteger const FTINAlertTagActivityCancel = 1;

@interface FTINActivityViewController ()
{
}

- (void)pause:(id)sender;
- (void)setupNavigationItemBarButtons:(BOOL)animated;

@end

@implementation FTINActivityViewController

#pragma mark - Super methods

- (void)dealloc
{
	_actionToolbar = nil;
	_cancelBarButton = nil;
	_nextBarButton = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
	
	if(!self.visible)
	{
		_actionToolbar = nil;
		_cancelBarButton = nil;
		_nextBarButton = nil;
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.leftItemsSupplementBackButton = NO;
	self.editButtonItem.title = @"hide_controls".localizedString;
	
	[self setupNavigationItemBarButtons:NO];
	
	NSMutableArray *actionButtons = [NSMutableArray arrayWithArray:[self getActionBarButtons]];
	[actionButtons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
	[actionButtons addObject:self.nextBarButton];
	self.actionToolbar.items = actionButtons;
	
	if(self.subActivity.data.completed)
	{
		UIView *completionOverlay = [[UIView alloc] initWithFrame:self.view.bounds];
		completionOverlay.backgroundColor = [UIColor blackColor];
		completionOverlay.layer.opacity = .25f;
		[self.view addSubview:completionOverlay];
		
		[self.view bringSubviewToFront:self.actionToolbar];
	}
	
	self.view.backgroundColor = [FTINStyler backgroundColor];
}

- (void)setEditing:(BOOL)editing
{
	[self setEditing:editing animated:NO];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	
	CGRect toolbarFrame = self.actionToolbar.frame;
	toolbarFrame.origin.y = self.view.frame.size.height;
	
	if(!editing)
	{
		[self setupNavigationItemBarButtons:animated];
		toolbarFrame.origin.y -= toolbarFrame.size.height;
		self.editButtonItem.title = @"hide_controls".localizedString;
	}
	else
	{
		[self.navigationItem setLeftBarButtonItems:nil animated:animated];
		[self.navigationItem setRightBarButtonItems:@[self.editButtonItem] animated:animated];
		self.editButtonItem.title = @"show_controls".localizedString;
	}
	
	[UIView animateWithDuration:FTINDefaultAnimationDuration animations:^{
		self.actionToolbar.frame = toolbarFrame;
	}];
}

#pragma mark - Abstract and Hook methods

- (NSArray *)getActionBarButtons
{
	return @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
}

- (NSArray *)getNavigationItemRightBarButtons
{
	return @[];
}

#pragma mark - Instance methods

- (id)initWithSubActivity:(FTINSubActivityDetails *)subactivity andDelegate:(id<FTINActivityViewControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        _subActivity = subactivity;
		self.title = _subActivity.content.title;
		self.delegate = delegate;
    }
    return self;
}

@synthesize cancelBarButton = _cancelBarButton;

- (UIBarButtonItem *)cancelBarButton
{
	if(!_cancelBarButton) {
		_cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"cancel".localizedString style:UIBarButtonItemStyleBordered target:self action:@selector(cancelActivity:)];
	}
	return _cancelBarButton;
}

@synthesize pauseBarButton = _pauseBarButton;

- (UIBarButtonItem *)pauseBarButton
{
	if(!_pauseBarButton) {
		_pauseBarButton = [[UIBarButtonItem alloc] initWithTitle:@"pause".localizedString style:UIBarButtonItemStyleBordered target:self action:@selector(pause:)];
	}
	return _pauseBarButton;
}

@synthesize actionToolbar = _actionToolbar;

- (UIToolbar *)actionToolbar
{
	if(!_actionToolbar)
	{
		_actionToolbar = [[UIToolbar alloc] init];
		_actionToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		[self.view addSubview:_actionToolbar];
		
		[_actionToolbar sizeToFit];
		
		CGRect frame = _actionToolbar.frame;
		frame.origin.y = self.view.frame.size.height - frame.size.height;
		frame.size.width = self.view.frame.size.width;
		_actionToolbar.frame = frame;
	}
	return _actionToolbar;
}

@synthesize nextBarButton = _nextBarButton;

- (UIBarButtonItem *)nextBarButton
{
	if(!_nextBarButton)
	{
		if ([self.delegate respondsToSelector:@selector(activityViewControllerCustomizedNextBarButton:)])
		{
			_nextBarButton = [self.delegate activityViewControllerCustomizedNextBarButton:self];
			
			if(_nextBarButton)
			{
				_nextBarButton.target = self;
				_nextBarButton.action = @selector(goToNextActivity:);
				return _nextBarButton;
			}
		}
		
		_nextBarButton = [[UIBarButtonItem alloc] initWithTitle:@"next>".localizedString style:UIBarButtonItemStyleBordered target:self action:@selector(goToNextActivity:)];
	}
	
	return _nextBarButton;
}

- (void)cancelActivity:(id)sender
{
	UIAlertView *alertView = [UIAlertView alertWithConfirmation:@"leave_activity".localizedString delegate:self];
	alertView.tag = FTINAlertTagActivityCancel;
	[alertView show];
}

- (void)pause:(id)sender
{
	[self.delegate activityViewControllerPaused:self];
}

- (void)goToNextActivity:(id)sender
{
	if([self prepareToGoToNextActivity])
	{
		[self.delegate activityViewControllerFinished:self];
	}
}

- (BOOL)prepareToGoToNextActivity
{
	return YES;
}

- (void)setupNavigationItemBarButtons:(BOOL)animated
{
	[self.navigationItem setLeftBarButtonItems:@[self.cancelBarButton, self.pauseBarButton] animated:animated];
	
	NSMutableArray *rightButtons = [NSMutableArray arrayWithObject:self.editButtonItem];
	
	if([self.delegate respondsToSelector:@selector(activityViewControllerAdditionalRightBarButtonItems:)])
	{
		[rightButtons addObjectsFromArray:[self.delegate activityViewControllerAdditionalRightBarButtonItems:self].reverseObjectEnumerator.allObjects];
	}
	
	[rightButtons addObjectsFromArray:[self getNavigationItemRightBarButtons].reverseObjectEnumerator.allObjects];
	[self.navigationItem setRightBarButtonItems:rightButtons animated:animated];
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex != alertView.cancelButtonIndex)
	{
		if(alertView.tag == FTINAlertTagActivityCancel)
		{
			[self.delegate activityViewControllerCanceled:self];
		}
	}
}

@end
