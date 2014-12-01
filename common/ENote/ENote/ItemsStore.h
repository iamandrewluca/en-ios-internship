//
//  ItemsStore.h
//  ENote
//
//  Created by Andrei Luca on 11/28/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "Store.h"

@class Item;

@interface ItemsStore : Store

@property (nonatomic, copy, readonly) NSString *storePath;

- (instancetype)initInFolder:(NSString *)folder;
- (void)saveItem:(Item *)item;

@end
