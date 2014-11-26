//
//  StoreItem.m
//  ENote
//
//  Created by Andrei Luca on 11/25/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "StoreItem.h"

@implementation StoreItem

#pragma mark Initialization

- (instancetype)init {
    return [self initWithName:@"Just an StoreItem"];
}

- (instancetype)initWithName:(NSString *)name {
    return [self initWithName:name atDate:[NSDate date] andFolder:[[NSUUID UUID] UUIDString]];
}

- (instancetype)initWithName:(NSString *)name atDate:(NSDate *)date andFolder:(NSString *)folder {
    
    self = [super init];
    
    if (self) {
        _name = name;
        _dateCreated = date;
        _itemFolder = folder;
    }
    
    return self;
}

#pragma mark Other forms

- (NSMutableDictionary *)dictionaryRepresentation {
    return [[NSMutableDictionary alloc] initWithDictionary:@{
                                                             @"name": _name,
                                                             @"notebookFolder": _itemFolder,
                                                             @"dateCreated": [NSString stringWithFormat:@"%.0f", [_dateCreated timeIntervalSince1970]]
                                                             }];
}

@end
