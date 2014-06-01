//
//  NSDate+FormattedDate.m
//  FanChorusScreamCreator
//
//  Created by Luiz Soares dos Santos Baglie on 2014/03/18.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "NSDate+FormattedDate.h"

@implementation NSDateFormatter (FormattedConstructor)

+ (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle andTimeStyle:(NSDateFormatterStyle)timeStyle
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeStyle:timeStyle];
	[formatter setDateStyle:dateStyle];
	return formatter;
}

+ (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle
{
	return [self dateFormatterWithDateStyle:dateStyle andTimeStyle:NSDateFormatterNoStyle];
}

+ (NSDateFormatter *)dateFormatterWithTimeStyle:(NSDateFormatterStyle)timeStyle
{
	return [self dateFormatterWithDateStyle:NSDateFormatterNoStyle andTimeStyle:timeStyle];
}

@end

@implementation NSDate (FormattedDate)

- (NSString *)formattedTimeWithStyle:(NSDateFormatterStyle)style
{
	NSString *time = [[NSDateFormatter dateFormatterWithTimeStyle:style] stringFromDate:self];
	return time;
}

- (NSString *)formattedTimeForFileNameWithStyle:(NSDateFormatterStyle)style
{
	return [[self formattedTimeWithStyle:style] stringByReplacingOccurrencesOfString:@":" withString:@"_"];
}

- (NSString *)formattedDateWithStyle:(NSDateFormatterStyle)style
{
	NSString *date = [[NSDateFormatter dateFormatterWithDateStyle:style] stringFromDate:self];
	return date;
}

- (NSString *)formattedDateForFileNameWithStyle:(NSDateFormatterStyle)style
{
	return [[self formattedDateWithStyle:style] stringByReplacingOcurrencesOfStrings:@[@"/", @","] withString:@"_"];
}

- (NSString *)formattedDateTimeWithDateStyle:(NSDateFormatterStyle)dateStyle andTimeStyle:(NSDateFormatterStyle)timeStyle
{
	NSString *dateTime = [[NSDateFormatter dateFormatterWithDateStyle:dateStyle andTimeStyle:timeStyle] stringFromDate:self];
	return dateTime;
}

- (NSString *)formattedDateTimeForFileNameWithDateStyle:(NSDateFormatterStyle)datestyle andTimeStyle:(NSDateFormatterStyle)timeStyle
{
	NSMutableString *originalDate = [NSMutableString stringWithString:[self formattedDateTimeWithDateStyle:datestyle andTimeStyle:timeStyle]];
	[originalDate replaceOccurrencesOfString:@"/" withString:@"-" options:NSLiteralSearch range:NSMakeRange(0, originalDate.length)];
	[originalDate replaceOccurrencesOfString:@":" withString:@"_" options:NSLiteralSearch range:NSMakeRange(0, originalDate.length)];
	[originalDate replaceOccurrencesOfString:@"," withString:@"" options:NSLiteralSearch range:NSMakeRange(0, originalDate.length)];
	
	return originalDate.description;
}

@end
