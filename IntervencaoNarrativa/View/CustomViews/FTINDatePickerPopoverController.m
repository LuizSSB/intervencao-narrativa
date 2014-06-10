//
//  FTINDatePickerPopoverController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINDatePickerPopoverController.h"

@interface FTINDatePickerPopoverController ()

@property (nonatomic, readonly) UIDatePicker *datePicker;

- (UIViewController *)createViewController;
- (void)datePicked:(UIDatePicker *)datePicker;

@end

@implementation FTINDatePickerPopoverController

#pragma mark - Super methods

- (void)dealloc
{
	[_datePicker removeObserver:self forKeyPath:NSStringFromSelector(@selector(date))];
	_datePicker = nil;
	_date = nil;
}

#pragma mark - Instance methods

- (instancetype)initWithDate:(NSDate *)date
{
    self = [self initWithContentViewController:[self createViewController]];
    if (self) {
		self.popoverContentSize = self.contentViewController.view.bounds.size;
        self.date = date;
    }
    return self;
}

@synthesize date = _date;

- (NSDate *)date
{
	if (!_date)
	{
		return [NSDate date];
	}
	
	return _date;
}

- (void)setDate:(NSDate *)date
{
	if (!date)
	{
		date = [NSDate date];
	}
	
	_date = date;
	_datePicker.date = date;
}

- (NSDate *)minimumDate
{
	return self.datePicker.minimumDate;
}

- (void)setMinimumDate:(NSDate *)minimumDate
{
	self.datePicker.minimumDate = minimumDate;
}

- (NSDate *)maximumDate
{
	return self.datePicker.maximumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate
{
	self.datePicker.maximumDate = maximumDate;
}

@synthesize datePicker = _datePicker;

- (UIDatePicker *)datePicker
{
	if(!_datePicker) {
		_datePicker = [[UIDatePicker alloc] init];
		_datePicker.datePickerMode = UIDatePickerModeDate;
		_datePicker.date = self.date;
		[_datePicker addTarget:self action:@selector(datePicked:) forControlEvents:UIControlEventValueChanged];
		[_datePicker sizeToFit];
	}
	
	return _datePicker;
}

- (UIViewController *)createViewController
{
	UIViewController *content = [[UIViewController alloc] init];
	content.view.frame = self.datePicker.bounds;
	[content.view addSubview:self.datePicker];
	
	return content;
}

- (void)datePicked:(UIDatePicker *)datePicker
{
	if(![self.date isEqualToDate:datePicker.date])
	{
		self.date = datePicker.date;
	}
}

@end
