//
//  FTINChoiceTableViewController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/04.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGSize const FTINChoicePopoverMaximumSize;

@class FTINChoiceViewController, FTINChoice;

@protocol FTINChoiceViewControllerDelegate <NSObject>

@optional

- (void)choiceViewController:(FTINChoiceViewController *)choiceViewController choseItemAtIndex:(NSInteger)itemIndex withMetadata:(FTINChoice *)metadata;

- (void)choiceViewController:(FTINChoiceViewController *)choiceViewController rejectedItemAtIndex:(NSInteger)itemIndex withMetadata:(FTINChoice *)metadata;

@end

@interface FTINChoiceViewController : UITableViewController

@property (nonatomic) NSInteger maximumChoices;
@property (nonatomic) CGFloat popoverWidth;
@property (nonatomic) NSArray *choices;
@property (nonatomic, readonly) NSSet *selectedChoicesIndexes;
@property (nonatomic, readonly) NSSet *unselectedChoicesIndexes;
@property (nonatomic, weak) id<FTINChoiceViewControllerDelegate> delegate;

- (id)initWithChoices:(NSArray *)choices;
- (void)setup;
- (BOOL)canChooseQuestionAt:(NSInteger)index;

- (NSDictionary *)getSelectedChoices;
- (void)chooseItemAtIndex:(NSInteger)index;
- (void)rejectItemAtIndex:(NSInteger)index;
- (void)rejectAll;
- (BOOL)isIndexChosen:(NSInteger)index;
- (BOOL)hasSelectedChoice;

- (void)presentAsPopoverFromBarButtonItem:(UIBarButtonItem *)button animated:(BOOL)animated;
- (void)dismissPopoverAnimated:(BOOL)animated;

@end
