//
//  Macros.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/22.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

NSTimeInterval const FTINDefaultAnimationDuration = .3;
NSTimeInterval const FTINDefaultAnimationShortDuration = .15;
NSString * const FTINDefaultCellIdentifier = @"Cell";
NSString * const FTINDefaultNamespace = @"FTIN";
NSString * const FTINDefaultCheckedValue = @"X";

#warning FIXME voltar para mainActivity antes de distribuir
//NSString * const FTINDefaultActivityFileName = @"mainActivity";
NSString * const FTINDefaultActivityFileName = @"debugActivity";
NSString * const FTINDefaultActivityFileExtension = @"json";

CGFloat const FTINBarButtonItemSpacing = 20.f;

NSString * const FTINHTMLClassExecuted = @"executed";
NSString * const FTINHTMLClassSkipped = @"skipped";
NSString * const FTINHTMLClassFailed = @"failed";
NSString * const FTINTemplateKeyElementClass = @"class";
NSString * const FTINTemplateKeyElementValue = @"value";

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
