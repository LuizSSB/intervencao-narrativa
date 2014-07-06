//
//  Macros.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/22.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

NSTimeInterval const FTINDefaultAnimationDuration = .3;
NSTimeInterval const FTINDefaultAnimationShortDuration = .15;
CGFloat const FTINBarButtonItemSpacing = 20.f;
NSString * const FTINDefaultCellIdentifier = @"Cell";
NSString * const FTINDefaultNamespace = @"FTIN";

#warning FIXME voltar para mainActivity antes de distribuir
//NSString * const FTINDefaultActivityFileName = @"mainActivity";
NSString * const FTINDefaultActivityFileName = @"debugActivity";
NSString * const FTINDefaultActivityFileExtension = @"json";

NSString * FTINActivityTypeTitle(FTINActivityType type)
{
	NSString *key = nil;
	
	switch (type)
	{
		case FTINActivityTypeWhyGame:
			key = @"activity_whygame";
			break;
			
		case FTINActivityTypeArrangement:
			key = @"activity_arrangement";
			break;
			
		case FTINActivityTypeDescription:
			key = @"activity_description";
			break;
			
		case FTINActivityTypeEnvironment:
			key = @"activity_environment";
			break;
	}
	
	return key.localizedString;
}
