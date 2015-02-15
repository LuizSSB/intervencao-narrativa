//
//  FTINActivityInstructionViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2/14/15.
//  Copyright (c) 2015 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINActivityInstructionViewController.h"

@interface FTINActivityInstructionViewController ()
{
	FTINActivityType _type;
}
@property (weak, nonatomic) IBOutlet UILabel *activityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
- (IBAction)close:(id)sender;

@end

@implementation FTINActivityInstructionViewController

- (instancetype)initWithActivityType:(FTINActivityType)type
{
	self = [super init];
	if (self) {
		_type = type;
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.activityNameLabel.text = FTINActivityTypeTitle(_type);
	self.instructionLabel.text = FTINActivityTypeInstruction(_type);
}

- (IBAction)close:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end
