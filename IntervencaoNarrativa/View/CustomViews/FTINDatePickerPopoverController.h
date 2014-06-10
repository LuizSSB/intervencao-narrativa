//
//  FTINDatePickerPopoverController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTINDatePickerPopoverController : UIPopoverController

@property (nonatomic) NSDate *date;
@property (nonatomic) NSDate *minimumDate;
@property (nonatomic) NSDate *maximumDate;

- (id)initWithDate:(NSDate *)date;

@end
