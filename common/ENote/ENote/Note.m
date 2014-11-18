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

- (NSDictionary *)dictionaryRepresentation {
    
    return @{
             @"name": _name,
             @"text": _text,
             @"notebookFolder": _noteFolder,
             @"dateCreated": [NSString stringWithFormat:@"%.0f", [_dateCreated timeIntervalSince1970]]
             };
    
}

- (instancetype)init {
    return [self initWithName:@"Just a Note"];
}

- (instancetype)initWithName:(NSString *)name {
    return [self initWithName:name withText:@"" atDate:[NSDate date] andFolder:[[NSUUID UUID] UUIDString]];
}

- (instancetype)initWithName:(NSString *)name withText:text atDate:(NSDate *)date andFolder:(NSString *)folder {
    
    self = [super init];
    
    if (self) {
        
        _name = name;
        _text = text;
        _noteFolder = folder;
        _dateCreated = date;
        
    }
    
    return self;
}

@end
