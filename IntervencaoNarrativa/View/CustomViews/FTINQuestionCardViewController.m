//
//  FTINQuestionCardViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINQuestionCardViewController.h"
#import "FTINWhyGameQuestion.h"
#import "FTINAnswerSkillChoiceViewController.h"

CGFloat const FTINQuestionCardViewControllerMinimumOpacity = .1f;

@interface FTINQuestionCardViewController () <UIPopoverControllerDelegate>
{
	CGSize _originalViewSize;
}

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *questionMarkImageView;
@property (weak, nonatomic) IBOutlet UITextView *answerTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *answerSkillBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *answerVisibilityBarButton;
@property (weak, nonatomic) IBOutlet UIToolbar *actionToolbar;

- (IBAction)toggleAnswerVisibility:(id)sender;
- (IBAction)close:(id)sender;
- (IBAction)showAnswerSkill:(id)sender;

@property (nonatomic, readonly) FTINAnswerSkillChoiceViewController *answerViewController;

@end

@implementation FTINQuestionCardViewController

#pragma mark - Super methods

- (void)dealloc
{
	_question = nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.question = self.question;
	self.answerSkillBarButton.tintColor = self.answerVisibilityBarButton.tintColor = [UIBarButtonItem appearance].tintColor;
	
	if(self.answered)
	{
		[self.answerSkillBarButton setTitle:@"correct_marking".localizedString];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.showsAnswerVisiblityControl = self.showsAnswerVisiblityControl;
	_originalViewSize = self.view.frame.size;
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	CGRect frame = self.view.superview.frame;
	frame.origin.x += (frame.size.width - _originalViewSize.width) / 2.f;
	frame.origin.y += (frame.size.height - _originalViewSize.height) / 2.f;
	frame.size = _originalViewSize;
	self.view.superview.frame = frame;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	if(self.answerTextView.layer.opacity > 0.f) {
		[self toggleAnswerVisibility:self];
	}
}

#pragma mark - Instance methods

- (instancetype)initWithQuestion:(FTINWhyGameQuestion *)question andDelegate:(id<FTINQuestionCardViewControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
		self.question = question;
        self.delegate = delegate;
		self.modalPresentationStyle = UIModalPresentationFormSheet;
		_showsAnswerVisiblityControl = YES;
    }
    return self;
}

- (void)setQuestion:(FTINWhyGameQuestion *)question
{
	_question = question;
	
	if(question.answered)
	{
		self.answerSkill = question.answerSkill;
	}
	else
	{
		[self.answerViewController rejectAll];
	}
	
	self.questionLabel.text = question.question;
	self.answerTextView.text = question.answer;
}

- (void)setShowsAnswerVisiblityControl:(BOOL)showsAnswerVisiblityControl
{
	if(self.answerTextView.layer.opacity > 0)
	{
		[self toggleAnswerVisibility:self];
	}
	
	self.actionToolbar.hidden = NO;
	[UIView animateWithDuration:FTINDefaultAnimationDuration animations:^{
		CGRect toolbarFrame = self.actionToolbar.frame;
		toolbarFrame.origin.y = self.actionToolbar.superview.frame.size.height;
		
		if(showsAnswerVisiblityControl)
		{
			toolbarFrame.origin.y -= toolbarFrame.size.height;
		}
		
		self.actionToolbar.frame = toolbarFrame;
	} completion:^(BOOL finished) {
		self.actionToolbar.hidden = !showsAnswerVisiblityControl;
	}];
	
	_showsAnswerVisiblityControl = showsAnswerVisiblityControl;
}

- (IBAction)toggleAnswerVisibility:(id)sender {
	self.answerVisibilityBarButton.title = (self.answerTextView.layer.opacity > 0 ? @"show_answer" : @"hide_answer").localizedString;
	
	[UIView animateWithDuration:FTINDefaultAnimationDuration animations:^{
		self.questionMarkImageView.layer.opacity = MAX(self.answerTextView.layer.opacity, FTINQuestionCardViewControllerMinimumOpacity);
		self.answerTextView.layer.opacity = fabs(1.f - self.answerTextView.layer.opacity);
	}];
}

- (IBAction)close:(id)sender {
	if(self.answered)
	{
		[self.delegate questionCardViewController:self finishedWithAnswerSkill:self.answerSkill];
	}
	else
	{
		[self.delegate questionCardViewControllerCanceled:self];
	}
}

- (BOOL)answered
{
	return self.answerViewController.hasSelectedChoice;
}

- (FTINAnswerSkill)answerSkill
{
	return self.answerViewController.selectedSkill;
}

- (void)setAnswerSkill:(FTINAnswerSkill)answerSkill
{
	self.answerViewController.selectedSkill = answerSkill;
}

- (void)removeAnswerSkill
{
	if(self.answerViewController.hasSelectedChoice)
	{
		self.answerViewController.allowsUnselection = YES;
		[self.answerViewController rejectItemAtIndex:self.answerViewController.selectedChoiceIndex];
		self.answerViewController.allowsUnselection = NO;
	}
}

- (void)showAnswerSkill:(id)sender
{
	UIPopoverController *popover = [self.answerViewController presentAsPopoverFromBarButtonItem:sender animated:YES];
	popover.delegate = self;
}

@synthesize answerViewController = _answerViewController;
- (FTINAnswerSkillChoiceViewController *)answerViewController
{
	if(!_answerViewController)
	{
		_answerViewController = [[FTINAnswerSkillChoiceViewController alloc] init];
		_answerViewController.title = self.answerSkillBarButton.title;
		_answerViewController.popoverWidth = 400.f;
	}
	
	return _answerViewController;
}

#pragma mark - Popover Controller Delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	if(self.answerViewController.hasSelectedChoice)
	{
		[self.answerSkillBarButton setTitle:@"correct_marking".localizedString];
	}
}

@end
