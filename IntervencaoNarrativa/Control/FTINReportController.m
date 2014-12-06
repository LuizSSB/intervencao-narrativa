//
//  FTINReportController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINReportController.h"
#import "FTINReportFormatter.h"

@interface FTINReportController ()

@property (nonatomic, readonly) FTINReportFormatter *formatter;

@end

@implementation FTINReportController

#pragma mark - Super methods

- (void)dealloc
{
	_activity = nil;
	_formatter = nil;
}

#pragma mark - Instance methods

- (instancetype)initWithActivity:(Activity *)activity andDelegate:(id<FTINReportControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
		self.activity = activity;
        self.delegate = delegate;
    }
    return self;
}

- (void)setActivity:(Activity *)activity
{
	_activity = activity;
	_formatter.activity = activity;
}

- (void)processReportType:(FTINActivityType)type
{
	[NSThread runOnGlobalQueueWithDefaultPriority:^{
		NSError *error = nil;
		NSString *parsed = [self.formatter createReportForActivitiesOfType:type error:&error];
		
		[NSThread runOnMainQueue:^{
			[self.delegate reportController:self generatedReport:parsed withError:error];
		}];
	}];
}

- (void)processScoreReport
{
	[NSThread runOnGlobalQueueWithDefaultPriority:^{
		NSError *error = nil;
		NSString *parsed = [self.formatter createScoreReportWithError:&error];
		
		[NSThread runOnMainQueue:^{
			[self.delegate reportController:self generatedReport:parsed withError:error];
		}];
	}];
}

@synthesize formatter = _formatter;
- (FTINReportFormatter *)formatter
{
	if(!_formatter)
	{
		_formatter = [[FTINReportFormatter alloc] initWithActivity:self.activity];
	}
	
	return _formatter;
}

@end
