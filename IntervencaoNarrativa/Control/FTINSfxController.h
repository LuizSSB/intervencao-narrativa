//
//  FTINSfxController.h
//  IntervencaoNarrativa
//
//  Created by Luiz SSB on 6/27/15.
//  Copyright (c) 2015 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const FTINSfxDefaultExtension;

@interface FTINSfxController : NSObject

+ (instancetype)sharedController;

- (void)playSfx:(NSString *)sfx ofExtension:(NSString *)extension;

@end
