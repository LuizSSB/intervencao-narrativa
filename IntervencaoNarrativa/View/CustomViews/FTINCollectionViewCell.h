//
//  FTINCollectionViewCell.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/11.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTINCollectionViewCell : UICollectionViewCell

@property (nonatomic) IBOutlet UIImageView *backgroundImageView;

+ (NSString *)cellIdentifier;

@end
