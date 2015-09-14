//
//  FTINSfxController.m
//  IntervencaoNarrativa
//
//  Created by Luiz SSB on 6/27/15.
//  Copyright (c) 2015 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINSfxController.h"

#import <AudioToolbox/AudioToolbox.h>

NSString * const FTINSfxDefaultExtension = @"m4a";

@implementation FTINSfxController

static FTINSfxController *_instance;

+ (instancetype)sharedController
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_instance = [[FTINSfxController alloc] init];
	});
	
	return _instance;
}

- (void)playSfx:(NSString *)sfx ofExtension:(NSString *)extension
{
	NSURL *file = [[NSBundle mainBundle] URLForResource:sfx withExtension:extension];
	SystemSoundID soundId;
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)file, &soundId);
	AudioServicesAddSystemSoundCompletion(soundId, NULL, NULL, playSoundFinished, NULL);
	AudioServicesPlaySystemSound(soundId);
}

static void playSoundFinished(SystemSoundID soundID, void *data) {
	AudioServicesDisposeSystemSoundID(soundID);
}

@end
