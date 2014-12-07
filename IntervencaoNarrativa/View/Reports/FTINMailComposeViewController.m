//
//  FTINMailComposeViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINMailComposeViewController.h"

@interface FTINMailComposeViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation FTINMailComposeViewController

#pragma mark - Instance methods

- (instancetype)init:(NSError *__autoreleasing *)error
{
	if(![MFMailComposeViewController canSendMail])
	{
		[NSError ftin_createErrorWithCode:FTINErrorCodeMailNotPossible inReference:error];
		return nil;
	}
	
    self = [super init];
    if (self) {
		self.mailComposeDelegate = self;
    }
    return self;
}

#pragma mark - Mail Compose View Controller Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[NSError alertOnError:error andDoOnSuccess:^{
		[self dismissViewControllerAnimated:YES completion:nil];
	}];
}

@end
