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

+ (instancetype)sharedStore;
- (StoreItem *)createStoreItem;
- (StoreItem *)createStoreItemWithName:(NSString *)name;
- (StoreItem *)createStoreItemWithName:(NSString *)name atDate:(NSDate *)date andFolder:(NSString *)folder;
- (void)removeStoreItem:(StoreItem *)storeItem;
- (void)renameStoreItem:(StoreItem *)storeItem withName:(NSString *)name;

@end
