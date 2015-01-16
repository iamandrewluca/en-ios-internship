//
//  NSDate+IfDay.m
//  ENote
//
//  Created by Andrei Luca on 1/16/15.
//  Copyright (c) 2015 Endava. All rights reserved.
//

#import "NSDate+IfDay.h"

@implementation NSDate (IfDay)

- (BOOL)isToday
{
    NSInteger todayDay = [[NSDate date] dayOfYear];
    NSInteger selfDay = [self dayOfYear];
    
    return todayDay == selfDay;
}

- (BOOL)isBehindTodayWithDaysMoreThen:(NSInteger)days
{
    NSInteger todayDay = [[NSDate date] dayOfYear];
    NSInteger selfDay = [self dayOfYear];
    
    return selfDay <= todayDay - days;
}

- (NSInteger)dayOfYear
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSInteger day = [currentCalendar ordinalityOfUnit:NSCalendarUnitDay
                                               inUnit:NSCalendarUnitYear
                                              forDate:self];
    
    return day;
}

@end
