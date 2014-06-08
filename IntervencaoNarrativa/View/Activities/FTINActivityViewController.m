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
	
	self.navigationItem.backBarButtonItem = nil;
	self.navigationItem.leftBarButtonItem = self.cancelButton;
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.editButtonItem.title = @"hide_controls".localizedString;
	
	NSMutableArray *actionButtons = [NSMutableArray arrayWithArray:[self getActionBarButtons]];
	[actionButtons addObject:self.nextButton];
	self.actionToolbar.items = actionButtons;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
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
		_nextButton = [[UIBarButtonItem alloc] initWithTitle:@"next>".localizedString style:UIBarButtonItemStyleBordered target:self action:@selector(goToNextActivity:)];
	}
	return _nextButton;
}

- (void)cancelActivity:(id)sender
{
	[[UIAlertView alertWithConfirmation:@"leave_activity".localizedString delegate:self] show];
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
		[self.delegate activityViewControllerCanceled:self];
	}
}

@end
