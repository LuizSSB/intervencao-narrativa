//
//  NSDate+FormattedDate.h
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/18.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (FormattedConstructor)

+ (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle andTimeStyle:(NSDateFormatterStyle)timeStyle;
+ (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle;
+ (NSDateFormatter *)dateFormatterWithTimeStyle:(NSDateFormatterStyle)timeStyle;

@end

@interface NSDate (FormattedDate)

- (NSString *)formattedTimeWithStyle:(NSDateFormatterStyle)style;
- (NSString *)formattedTimeForFileNameWithStyle:(NSDateFormatterStyle)style;

- (NSString *)formattedDateWithStyle:(NSDateFormatterStyle)style;
- (NSString *)formattedDateForFileNameWithStyle:(NSDateFormatterStyle)style;

- (NSString *)formattedDateTimeWithDateStyle:(NSDateFormatterStyle)dateStyle andTimeStyle:(NSDateFormatterStyle)timeStyle;
- (NSString *)formattedDateTimeForFileNameWithDateStyle:(NSDateFormatterStyle)datestyle andTimeStyle:(NSDateFormatterStyle)timeStyle;


@end
