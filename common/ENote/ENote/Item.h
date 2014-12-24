//
//  StoreItem.h
//  ENote
//
//  Created by Andrei Luca on 11/25/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic, copy, readonly) NSString *ID;
@property (nonatomic, copy, readonly) NSDate *dateCreated;
@property (nonatomic, copy) NSString *name;

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSMutableDictionary *)dictionaryRepresentation;

@end
