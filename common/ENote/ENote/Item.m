//
//  StoreItem.m
//  ENote
//
//  Created by Andrei Luca on 11/25/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "Item.h"

@implementation Item

- (instancetype)init
{
    return [self initWithName:@"Item Sample"];
}

- (instancetype)initWithName:(NSString *)name
{
    return [self initWithName:name withID:[[NSUUID UUID] UUIDString] atDate:[NSDate date]];
}

- (instancetype)initWithName:(NSString *)name withID:(NSString *)ID atDate:(NSDate *)date
{
    self = [super init];
    
    if (self) {
        _ID = ID;
        _name = name;
        _dateCreated = date;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    return [self initWithName:dictionary[@"name"]
                       withID:dictionary[@"ID"]
                       atDate:[NSDate dateWithTimeIntervalSince1970:[dictionary[@"dateCreated"] doubleValue]]];
}

- (NSMutableDictionary *)dictionaryRepresentation
{
    return [[NSMutableDictionary alloc] initWithDictionary:@{
                                                             @"ID": _ID,
                                                             @"name": _name,
                                                             @"dateCreated": [NSString stringWithFormat:@"%.0f", [_dateCreated timeIntervalSince1970]]
                                                             }];
}

@end
