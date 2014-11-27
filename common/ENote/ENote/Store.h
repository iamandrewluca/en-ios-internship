//
//  Store.h
//  ENote
//
//  Created by Andrei Luca on 11/25/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StoreItem;

@interface Store : NSObject

@property (nonatomic) NSArray *allStoreItems;
@property (nonatomic, copy, readonly) NSString *storePath;

- (instancetype)initInFolder:(NSString *)folder;
- (void)addStoreItem:(StoreItem *)storeItem;
- (StoreItem *)storeItemFromDictionary:(NSDictionary *)dictionary;
- (void)saveStoreItem:(StoreItem *)storeItem;
- (void)removeStoreItem:(StoreItem *)storeItem;
- (NSArray *)getValidStoreItemsPaths;

@end
