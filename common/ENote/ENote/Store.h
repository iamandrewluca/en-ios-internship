//
//  Store.h
//  ENote
//
//  Created by Andrei Luca on 11/25/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Item;

@interface Store : NSObject

@property (nonatomic) NSArray *allItems;

- (void)addItem:(Item *)item;
- (void)removeItem:(Item *)item;
- (Item *)itemFromDictionary:(NSDictionary *)dictionary;

@end
