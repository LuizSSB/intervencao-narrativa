//
//  FTINDraggableItemBoxView.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/14.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTINDraggableItemBoxView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic) NSArray *toolboxElements;
@property (nonatomic) NSSet *chosenElements;

- (void)reset:(BOOL)animated;

@end
