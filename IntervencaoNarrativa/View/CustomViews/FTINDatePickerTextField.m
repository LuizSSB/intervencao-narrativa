//
//  FTINDatePickerTextField.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINDatePickerTextField.h"
#import "FTINDatePickerPopoverController.h"

@interface FTINDatePickerTextField ()

@property (nonatomic, readonly) FTINDatePickerPopoverController *datePickerController;

@end

@implementation FTINDatePickerTextField

static void *FTINDatePickedContext = &FTINDatePickedContext;

#pragma mark - Super methods

- (void)dealloc
{
	[_datePickerController removeObserver:self forKeyPath:NSStringFromSelector(@selector(date))];
	_datePickerController = nil;
}

- (BOOL)becomeFirstResponder {
	if(self.isFirstResponder)
	{
		return NO;
	}
	
	[self.datePickerController presentPopoverFromRect:self.frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
	return YES;
}

- (BOOL)resignFirstResponder
{
	if([super resignFirstResponder])
	{
		[self.datePickerController dismissPopoverAnimated:YES];
		return YES;
	}
	
	return NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if(context == FTINDatePickedContext)
	{
		if (self.date != self.datePickerController.date)
		{
			self.date = self.datePickerController.date;
		}
	}
}

#pragma mark - Instance methods

- (void)setDate:(NSDate *)date
{
	_date = date;
	_datePickerController.date = date;
	self.text = [date formattedDateWithStyle:NSDateFormatterShortStyle];
	
	[self sendActionsForControlEvents:UIControlEventEditingChanged];
}

- (NSDate *)minimumDate
{
	return self.datePickerController.minimumDate;
}

- (void)setMinimumDate:(NSDate *)minimumDate
{
	self.datePickerController.minimumDate = minimumDate;
}

- (NSDate *)maximumDate
{
	return self.datePickerController.maximumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate
{
	self.datePickerController.maximumDate = maximumDate;
}

@synthesize datePickerController = _datePickerController;

- (FTINDatePickerPopoverController *)datePickerController
{
	if(!_datePickerController)
	{
		_datePickerController = [[FTINDatePickerPopoverController alloc] initWithDate:self.date];
		[_datePickerController addObserver:self forKeyPath:NSStringFromSelector(@selector(date)) options:NSKeyValueObservingOptionNew context:FTINDatePickedContext];
	}
	
	return _datePickerController;
}

@end
