//
//  FTINReportSelectionViewController.h
//  IntervencaoNarrativa
//
//  Essa tela poderia ser um UITableViewController, no entanto, como eu acho que
//  ela vai ser bastante customizada, é mais flexível usar composição mesmo.
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;

@interface FTINActivityResultViewController : UIViewController

+ (UIViewController *)viewControllerWithActivity:(Activity *)activity;

@property (nonatomic) Activity *activity;

@end
