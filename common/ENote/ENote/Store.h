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
- (StoreItem *)createStoreItem;
- (StoreItem *)createStoreItemWithName:(NSString *)name;
- (StoreItem *)createStoreItemWithDictionary:(NSDictionary *)dictionary;
- (void)saveStoreItem:(StoreItem *)storeItem;
- (void)removeStoreItem:(StoreItem *)storeItem;
- (void)renameStoreItem:(StoreItem *)storeItem withName:(NSString *)name;
- (NSArray *)getValidStoreItemsPaths;

@end
