//
//  NSDate+IfDay.h
//  ENote
//
//  Created by Andrei Luca on 1/16/15.
//  Copyright (c) 2015 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (IfDay)

- (BOOL)isToday;
- (BOOL)isBehindTodayWithDaysMoreThen:(NSInteger)days;
- (NSInteger)dayOfYear;

@end
