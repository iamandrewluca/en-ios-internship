//
//  Store.m
//  ENote
//
//  Created by Andrei Luca on 11/25/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "Store.h"
#import "Item.h"
#import "ENoteCommons.h"

@interface Store ()

@property (nonatomic, readonly) NSMutableArray *allPrivateItems;

@end

@implementation Store

#pragma mark Initialization

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        _allPrivateItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark Item Related

- (void)addItem:(Item *)item {
    [_allPrivateItems addObject:item];
}

- (void)removeItem:(Item *)item {
    [_allPrivateItems removeObject:item];
}

- (NSArray *)allItems {
    return _allPrivateItems;
}

- (Item *)itemFromDictionary:(NSDictionary *)dictionary {
    return [[Item alloc] initWithDictionary:dictionary];
}

@end
