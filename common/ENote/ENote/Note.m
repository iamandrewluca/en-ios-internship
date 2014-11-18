//  Note.m
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "Note.h"

@interface Note ()

@property (nonatomic, strong, readwrite) NSURL *imageURL;
@property (nonatomic, strong, readwrite) UIImage *noteImage;

@end

@implementation Note

- (instancetype)init {
    return [self initWithText:@"Just a Note"];
}

- (instancetype)initWithText:(NSString *)text {
    return [self initWithText:text atDate:[NSDate date] andFolder:[[NSUUID UUID] UUIDString]];
}

- (instancetype)initWithText:(NSString *)text atDate:(NSDate *)date andFolder:(NSString *)folder {
    
    self = [super init];
    
    if (self) {
        
        _text = text;
        _noteFolder = folder;
        _dateCreated = date;
        
    }
    
    return self;
}

@end
