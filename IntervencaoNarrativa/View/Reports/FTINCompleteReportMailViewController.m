//
//  FTINCompleteReportMailViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINCompleteReportMailViewController.h"
#import "Acitivity+Complete.h"
#import "Patient+Complete.h"

@interface FTINCompleteReportMailViewController () <MFMailComposeViewControllerDelegate>

- (void)setup:(Activity *)activity;

@end

@implementation FTINCompleteReportMailViewController

#pragma mark - Instance methods

- (instancetype)initWithActivity:(Activity *)activity error:(NSError *__autoreleasing *)error
{
    self = [super init:error];
	
	if(*error)
	{
		return nil;
	}
	
    if (self) {
		[self setup:activity];
    }
    return self;
}

- (void)setup:(Activity *)activity
{
	[self setSubject:[NSString stringWithFormat:@"full_report_mail_subject".localizedString, activity.title, [activity.creationDate formattedDateWithStyle:NSDateFormatterShortStyle], activity.patient.name]];
#warning TODO definir corpo.
}

@end
