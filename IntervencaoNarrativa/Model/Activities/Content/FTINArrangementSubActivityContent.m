//
//  FTINOrderingActivityContent.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/10.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINArrangementSubActivityContent.h"
#import "ArrangementSubActivity.h"

@implementation FTINArrangementSubActivityContent

- (BOOL)validateWithData:(SubActivity *)data error:(NSError *__autoreleasing *)error
{
	if([super validateWithData:data error:error])
	{
		do
		{
			if(![data isKindOfClass:[ArrangementSubActivity class]]) {
				*error = [NSError ftin_createErrorWithCode:ftin_InvalidDataErrorCode];
				break;
			}
			
			ArrangementSubActivity *tr00Activity = (id) data;
			
			if(tr00Activity.itemsArrangement.count != self.elementsImages.count)
			{
				*error = [NSError ftin_createErrorWithCode:ftin_InvalidDataErrorCode];
				break;
			}
			
			NSInteger idx = 0;
			for (NSString *image in tr00Activity.itemsArrangement) {
				if(![image isEqualToString:_elementsImages[idx++]])
				{
					*error = [NSError ftin_createErrorWithCode:ftin_WrongArrangementOrder];
					break;
				}
			}
			
			if(*error) break;
			
			return YES;
		}
		while (NO);
	}
	
	return NO;
}

@end
