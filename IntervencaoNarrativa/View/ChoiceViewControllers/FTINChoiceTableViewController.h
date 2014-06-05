//
//  FTINChoiceTableViewController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/04.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FTINChoiceTableViewController, FTINChoice;

@protocol FTINChoiceTableViewControllerDelegate <NSObject>

- (NSArray *)choicesForChoiceTableViewController:(FTINChoiceTableViewController *)choiceViewController;

@optional

- (void)choiceTableViewController:(FTINChoiceTableViewController *)choiceViewController choseItemAtIndex:(NSInteger)itemIndex withMetadata:(FTINChoice *)metadata;

- (void)choiceTableViewController:(FTINChoiceTableViewController *)choiceViewController rejectedItemAtIndex:(NSInteger)itemIndex withMetadata:(FTINChoice *)metadata;

@end

@interface FTINChoiceTableViewController : UITableViewController

@property (nonatomic, readonly) NSArray *choices;
@property (nonatomic, weak) id<FTINChoiceTableViewControllerDelegate> delegate;

- (id)initWithDelegate:(id<FTINChoiceTableViewControllerDelegate>)delegate;

- (NSDictionary *)getSelectedChoices;
- (void)chooseItemAtIndex:(NSInteger)index;
- (void)rejectItemAtIndex:(NSInteger)index;
- (BOOL)isIndexChosen:(NSInteger)index;

@end
