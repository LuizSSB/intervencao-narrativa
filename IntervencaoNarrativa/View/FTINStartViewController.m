//
//  FTINDetailViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/05/28.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINStartViewController.h"
#import "FTINPatientViewController.h"
#import "FTINNewPatientViewControllerDelegate.h"

NSString * const FTINSegueNewPatient = @"NewPatient";

@interface FTINStartViewController ()
@end

@implementation FTINStartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if([segue.identifier isEqualToString:FTINSegueNewPatient])
	{
		FTINNewPatientViewControllerDelegate *newPatientDelegate = [[FTINNewPatientViewControllerDelegate alloc] init];
		((FTINPatientViewController *)segue.destinationViewController).delegate = newPatientDelegate;
	}
}

@end
