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

NSInteger const FTINAlertTagActivityCancel = 1;

@interface FTINActivityViewController ()
{
}

@end

@implementation FTINActivityViewController

#pragma mark - Super methods

- (void)dealloc
{
	_actionToolbar = nil;
	_cancelButton = nil;
	_nextButton = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
	
	if(!self.visible)
	{
		_actionToolbar = nil;
		_cancelButton = nil;
		_nextButton = nil;
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.leftItemsSupplementBackButton = NO;
	self.navigationItem.leftBarButtonItem = self.cancelButton;
	self.editButtonItem.title = @"hide_controls".localizedString;
	
	NSMutableArray *rightButtons = [NSMutableArray arrayWithObject:self.editButtonItem];
	[rightButtons addObjectsFromArray:[self getNavigationItemRightBarButtons].reverseObjectEnumerator.allObjects];
	self.navigationItem.rightBarButtonItems = rightButtons;
	
	NSMutableArray *actionButtons = [NSMutableArray arrayWithArray:[self getActionBarButtons]];
	[actionButtons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
	[actionButtons addObject:self.nextButton];
	self.actionToolbar.items = actionButtons;
}

- (void)setEditing:(BOOL)editing
{
	[self setEditing:editing animated:NO];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	
	UIBarButtonItem *leftButton;
	CGRect toolbarFrame = self.actionToolbar.frame;
	toolbarFrame.origin.y = self.view.frame.size.height;
	
	if(!editing)
	{
		leftButton = self.cancelButton;
		toolbarFrame.origin.y -= toolbarFrame.size.height;
		self.editButtonItem.title = @"hide_controls".localizedString;
	}
	else
	{
		self.editButtonItem.title = @"show_controls".localizedString;
	}
	
	[self.navigationItem setLeftBarButtonItem:leftButton animated:YES];
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

@synthesize cancelButton = _cancelButton;
- (UIBarButtonItem *)cancelButton
{
	if(!_cancelButton) {
		_cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"cancel".localizedString style:UIBarButtonItemStyleBordered target:self action:@selector(cancelActivity:)];
	}
	return _cancelButton;
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

@synthesize nextButton = _nextButton;

- (UIBarButtonItem *)nextButton
{
	if(!_nextButton)
	{
		if ([self.delegate respondsToSelector:@selector(activityViewControllerCustomizedNextBarButton:)])
		{
			_nextButton = [self.delegate activityViewControllerCustomizedNextBarButton:self];
			
			if(_nextButton)
			{
				_nextButton.target = self;
				_nextButton.action = @selector(goToNextActivity:);
				return _nextButton;
			}
		}
		
		_nextButton = [[UIBarButtonItem alloc] initWithTitle:@"next>".localizedString style:UIBarButtonItemStyleBordered target:self action:@selector(goToNextActivity:)];
	}
	
	return _nextButton;
}

- (void)cancelActivity:(id)sender
{
	UIAlertView *alertView = [UIAlertView alertWithConfirmation:@"leave_activity".localizedString delegate:self];
	alertView.tag = FTINAlertTagActivityCancel;
	[alertView show];
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
