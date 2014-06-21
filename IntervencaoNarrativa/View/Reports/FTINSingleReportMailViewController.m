//
//  FTINSingleReportMailViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINSingleReportMailViewController.h"
#import "Acitivity+Complete.h"
#import "Patient+Complete.h"

NSString * const FTINSingleReportMailImageMimeType = @"image/png";
NSString * const FTINSingleReportMailImageName = @"relatorio.png";

@interface FTINSingleReportMailViewController ()

- (void)setupForActivity:(Activity *)activity andView:(UIView *)view;

@end

@implementation FTINSingleReportMailViewController

#pragma mark - Instance methods

- (instancetype)initWithActivity:(Activity *)activity andView:(UIView *)reportView error:(NSError *__autoreleasing *)error
{
    self = [super init:error];
	
	if(*error)
	{
		return nil;
	}
	
    if (self) {
        [self setupForActivity:activity andView:reportView];
    }
    return self;
}

- (void)setupForActivity:(Activity *)activity andView:(UIView *)view
{
	[self setSubject:[NSString stringWithFormat:@"full_report_mail_subject".localizedString, activity.title, [activity.creationDate formattedDateWithStyle:NSDateFormatterShortStyle], activity.patient.name]];
#warning TODO definir corpo.
	[self addAttachmentData:UIImagePNGRepresentation([view asImage]) mimeType:FTINSingleReportMailImageMimeType fileName:FTINSingleReportMailImageName];
}

@end
