//
//  SubAcitivity+Complete.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/07.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "SubActivity+Complete.h"
#import "FTINSubActivityContent.h"

@implementation SubActivity (Complete)

static NSNumberFormatter *_scoreFormatter;

- (BOOL)valid:(NSError *__autoreleasing *)error
{
	return YES;
}

- (void)setupWithContent:(FTINSubActivityContent *)content
{
	self.representativeImageName = content.representativeImageName;
}

- (NSInteger)difficulty
{
	return self.difficultyNumber.integerValue;
}

- (void)setDifficulty:(NSInteger)difficulty
{
	self.difficultyNumber = @(difficulty);
}

- (FTINActivityStatus)status
{
	return (FTINActivityStatus) self.statusNumber.integerValue;
}

- (void)setStatus:(FTINActivityStatus)status
{
	FTINActivityStatus finalStatus;
	
	if(status == FTINActivityStatusCompletedButSkipped || status == FTINActivityStatusCompleted)
	{
		finalStatus = self.status == FTINActivityStatusIncompletePreviouslySkipped || self.status == FTINActivityStatusSkipped ? FTINActivityStatusCompletedButSkipped : FTINActivityStatusCompleted;
	}
	else if(status == FTINActivityStatusIncomplete || status == FTINActivityStatusIncompletePreviouslySkipped)
	{
		finalStatus = self.status == FTINActivityStatusCompletedButSkipped || self.status == FTINActivityStatusSkipped ? FTINActivityStatusIncompletePreviouslySkipped : FTINActivityStatusIncomplete;
	}
	else
	{
		finalStatus = status;
	}
	
	self.statusNumber = @(finalStatus);
}

- (BOOL)finished
{
	return self.executed || self.failed;
}

- (BOOL)executed
{
	return self.status == FTINActivityStatusCompleted || self.status == FTINActivityStatusCompletedButSkipped || self.status == FTINActivityStatusSkipped;
}

- (BOOL)everBeenSkipped
{
	FTINActivityStatus status = self.status;
	return status == FTINActivityStatusSkipped || status == FTINActivityStatusIncompletePreviouslySkipped || status == FTINActivityStatusCompletedButSkipped;
}

- (BOOL)failed
{
	return self.status == FTINActivityStatusFailed;
}

- (NSInteger)tries
{
	return self.triesNumber.integerValue;
}

- (void)setTries:(NSInteger)tries
{
	self.triesNumber = @(tries);
}

- (NSString *)representativeImagePath
{
	NSArray *imageNameParts = [self.representativeImageName componentsSeparatedByString:@"."];
	
	NSString  *extension = imageNameParts.count == 2 ? imageNameParts[1] : FTINDefaultActivityImageFileExtension;
	
	NSString *path =  [[NSBundle mainBundle] URLForResource:imageNameParts[0] withExtension:extension].path;
	
	if (!path)
	{
		for(int idxRes = 2; idxRes <= 3; ++idxRes)
		{
			NSString *imgName = [imageNameParts[0] stringByAppendingFormat:@"@%dx", idxRes];
			path = [[NSBundle mainBundle] URLForResource:imgName withExtension:extension].path;
			
			if(path) break;
		}
	}
	
	return path;
}

- (CGFloat)calculateScore
{
	[self doesNotRecognizeSelector:_cmd];
	return 0;
}

- (CGFloat)score
{
	if(self.status == FTINActivityStatusSkipped)
	{
		return FTINActivityScoreSkipped;
	}
	
	if(self.failed || !self.executed)
	{
		return 0.f;
	}	
	
	return MIN(MAX([self calculateScore], 0), FTINActivityScoreMax);
}

- (NSString *)formattedScore
{
	return @(self.score).scoreValue;
}

@end
