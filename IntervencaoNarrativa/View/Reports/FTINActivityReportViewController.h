//
//  FTINActivityReportViewController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/21.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;

@interface FTINActivityReportViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;
@property (nonatomic) Activity *activity;

@end
