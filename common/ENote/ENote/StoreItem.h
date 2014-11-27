//
//  StoreItem.h
//  ENote
//
//  Created by Andrei Luca on 11/25/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreItem : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *itemFolder;
@property (nonatomic, copy, readonly) NSDate *dateCreated;

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSMutableDictionary *)dictionaryRepresentation;

@end
