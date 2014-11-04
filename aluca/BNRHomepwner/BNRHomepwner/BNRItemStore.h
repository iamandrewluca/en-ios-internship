//
//  BNRItemStore.h
//  BNRHomepwner
//
//  Created by Andrei Luca on 10/16/14.
//  Copyright (c) 2014 Andrei Luca. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;

@interface BNRItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;
@property (nonatomic, readonly) NSArray *itemsAbove50;
@property (nonatomic, readonly) NSArray *itemsBelow50;

+ (instancetype)sharedStore;
- (BNRItem *)createItem;
- (void)removeItem:(BNRItem *)item;
- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (BOOL)saveChanges;
- (void)switchItem:(BNRItem *)item;

@end
