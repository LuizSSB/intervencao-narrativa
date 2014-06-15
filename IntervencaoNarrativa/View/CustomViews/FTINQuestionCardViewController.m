//
//  FTINQuestionCardViewController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/15.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINQuestionCardViewController.h"
#import "FTINWhyGameQuestion.h"

CGFloat const FTINQuestionCardViewControllerMinimumOpacity = .1f;

@interface FTINQuestionCardViewController ()

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *questionMarkImageView;
@property (weak, nonatomic) IBOutlet UITextView *answerTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *answerVisibilityBarButton;

- (IBAction)toggleAnswerVisibility:(id)sender;
- (IBAction)close:(id)sender;

@end

@implementation FTINQuestionCardViewController

#pragma mark - Super methods

- (void)dealloc
{
	_question = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.answerVisibilityBarButton.enabled = self.showsAnswerVisiblityControl;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	if(self.answerTextView.layer.opacity > 0.f) {
		[self toggleAnswerVisibility:self];
	}
}

#pragma mark - Instance methods

- (instancetype)initWithDelegate:(id<FTINQuestionCardViewControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)setQuestion:(FTINWhyGameQuestion *)question
{
	_question = question;
	self.questionLabel.text = question.question;
	self.answerTextView.text = question.answer;
}

- (BOOL)showsAnswerVisiblityControl
{
	return self.answerVisibilityBarButton.enabled;
}

- (void)setShowsAnswerVisiblityControl:(BOOL)showsAnswerVisiblityControl
{
	self.answerVisibilityBarButton.enabled = !showsAnswerVisiblityControl;
}

- (IBAction)toggleAnswerVisibility:(id)sender {
	self.answerVisibilityBarButton.title = (self.answerTextView.layer.opacity > 0 ? @"show_answer" : @"hide_answer").localizedString;
	
	[UIView animateWithDuration:FTINDefaultAnimationDuration animations:^{
		self.questionMarkImageView.layer.opacity = MAX(self.answerTextView.layer.opacity, FTINQuestionCardViewControllerMinimumOpacity);
		self.answerTextView.layer.opacity = fabs(1.f - self.answerTextView.layer.opacity);
	}];
}

- (IBAction)close:(id)sender {
	[self.delegate questionCardViewControllerFinished:self];
}

@end
