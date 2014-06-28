//
//  FTINDescriptionActivityViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/05.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINDescriptionActivityViewController.h"
#import "FTINChoiceViewController.h"
#import "FTINDescriptiveSkillChoiceViewController.h"
#import "FTINSubActivityDetails.h"
#import "FTINDescriptionSubActivityContent.h"

#import "DescriptionSubActivity+Complete.h"

NSInteger const FTINAlertTagActivitySkip = 2;

@interface FTINDescriptionActivityViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *descriptiveSkillBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *describedItensBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *advanceLevelBarButton;

- (IBAction)showDescribedItems:(UIBarButtonItem *)sender;
- (IBAction)showDescriptiveSkill:(UIBarButtonItem *)sender;
- (IBAction)advanceLevel:(id)sender;

@property (nonatomic, readonly) FTINChoiceViewController *elementsChoiceViewController;
@property (nonatomic, readonly) FTINDescriptiveSkillChoiceViewController *skillChoiceViewController;

@end

@implementation FTINDescriptionActivityViewController

#pragma mark - Super methods

- (void)dealloc
{
	self.descriptiveSkillBarButton = nil;
	self.describedItensBarButton = nil;
	self.advanceLevelBarButton = nil;
	_elementsChoiceViewController = nil;
	_skillChoiceViewController = nil;
	_content = nil;
}

- (instancetype)initWithSubActivity:(FTINSubActivityDetails *)subactivity andDelegate:(id<FTINActivityViewControllerDelegate>)delegate
{
    self = [super initWithSubActivity:subactivity andDelegate:delegate];
    if (self) {
        _content = (id) subactivity.content;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.mainImageView.image = [UIImage imageNamed:self.content.image];
}

- (NSArray *)getNavigationItemRightBarButtons
{
	UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	fixedSpace.width = FTINBarButtonItemSpacing;
	return @[
			 self.advanceLevelBarButton,
			 fixedSpace
			 ];
}

- (NSArray *)getActionBarButtons
{
	UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	fixedSpace.width = FTINBarButtonItemSpacing;
	
	return @[
			 self.describedItensBarButton,
			 fixedSpace,
			 self.descriptiveSkillBarButton
			 ];
}

- (BOOL)prepareToGoToNextActivity
{
	[self.skillChoiceViewController dismissPopoverAnimated:YES];
	[self.elementsChoiceViewController dismissPopoverAnimated:YES];
	
	DescriptionSubActivity *descriptionActivity = (DescriptionSubActivity *)self.subActivity.data;
	
	if(self.skillChoiceViewController.hasSelectedChoice)
	{
		descriptionActivity.descriptiveSkill = self.skillChoiceViewController.selectedSkill;
	}
	
	if(self.elementsChoiceViewController.hasSelectedChoice)
	{
		descriptionActivity.describedElements = self.elementsChoiceViewController.selectedChoicesIndexes;
	}
	
	return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[super alertView:alertView clickedButtonAtIndex:buttonIndex];
	
	if(alertView.cancelButtonIndex != buttonIndex && alertView.tag == FTINAlertTagActivitySkip)
	{
		[self.delegate activityViewControllerWantsToSkip:self];
	}
}

#pragma mark - Instance methods

- (IBAction)showDescribedItems:(UIBarButtonItem *)sender
{
	[self.skillChoiceViewController dismissPopoverAnimated:YES];
	[self.elementsChoiceViewController presentAsPopoverFromBarButtonItem:sender animated:YES];
}

- (IBAction)showDescriptiveSkill:(UIBarButtonItem *)sender
{
	[self.elementsChoiceViewController dismissPopoverAnimated:YES];
	[self.skillChoiceViewController presentAsPopoverFromBarButtonItem:sender animated:YES];
}

- (IBAction)advanceLevel:(id)sender
{
	UIAlertView *alert = [UIAlertView alertWithConfirmation:@"skip_level".localizedString delegate:self];
	alert.tag = FTINAlertTagActivitySkip;
	[alert show];
}

@synthesize elementsChoiceViewController = _elementsChoiceViewController;

- (FTINChoiceViewController *)elementsChoiceViewController
{
	if(!_elementsChoiceViewController)
	{
		_elementsChoiceViewController = [[FTINChoiceViewController alloc] initWithChoices:self.content.elements];
		_elementsChoiceViewController.title = self.describedItensBarButton.title;
	}
	
	return _elementsChoiceViewController;
}

@synthesize skillChoiceViewController = _skillChoiceViewController;

- (FTINDescriptiveSkillChoiceViewController *)skillChoiceViewController
{
	if(!_skillChoiceViewController)
	{
		_skillChoiceViewController = [[FTINDescriptiveSkillChoiceViewController alloc] init];
		_skillChoiceViewController.title = self.descriptiveSkillBarButton.title;
	}
	
	return _skillChoiceViewController;
}

@end
