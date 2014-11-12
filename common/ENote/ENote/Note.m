//
//  Note.m
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "Note.h"

@implementation Note

- (instancetype)init {
    return [self initWithText:@"Just a Note"];
}

- (instancetype)initWithText:(NSString *)text {
    
    self = [super init];
    
    if (self) {
        
        _text = text;
        _noteFolder = [[NSUUID UUID] UUIDString];
        _dateCreated = [NSDate date];
        
    }
    
    return self;
}

@end
