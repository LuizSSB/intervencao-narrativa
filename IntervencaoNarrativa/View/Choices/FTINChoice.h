//
//  FTINChoice.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/04.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTINChoice : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *detail;
@property (nonatomic) UIImage *image;

- (id)initWithTitle:(NSString *)title andImage:(UIImage *)image;
+ (FTINChoice *)choiceWithTitle:(NSString *)title andImage:(UIImage *)image;

+ (FTINChoice *)choiceWithTitle:(NSString *)title andDetail:(NSString *)detail andImage:(UIImage *)image;

- (instancetype)initWithTitle:(NSString *)title andDetail:(NSString *)detail andImage:(UIImage *)image;

@end
