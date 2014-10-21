//
//  BNRItemStore.m
//  BNRHomepwner
//
//  Created by Andrei Luca on 10/16/14.
//  Copyright (c) 2014 Andrei Luca. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@interface BNRItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation BNRItemStore

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        
        return;
        
    } else {
        
        BNRItem *item = self.privateItems[fromIndex];
        
        [self.privateItems removeObjectAtIndex:fromIndex];
        [self.privateItems insertObject:item atIndex:toIndex];
        
    }
}

- (void)removeItem:(BNRItem *)item
{
    NSString *key = item.itemKey;
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    
    [self.privateItems removeObjectIdenticalTo:item];
}

+ (instancetype)sharedStore
{
    static BNRItemStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return  sharedStore;
    
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singelton" reason:@"Use +[BNRItemStore sharedStore]" userInfo:nil];

    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        _privateItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *)allItems
{
    return self.privateItems;
}

- (BNRItem *)createItem
{
    BNRItem *item = [BNRItem randomItem];
    
    [self.privateItems addObject:item];
    
    return item;
}

@end
