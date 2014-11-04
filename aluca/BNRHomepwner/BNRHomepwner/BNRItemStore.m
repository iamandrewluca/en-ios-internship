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
#import "AppDelegate.h"

@interface BNRItemStore ()

@property (nonatomic) NSMutableArray *privateItems;
@property (nonatomic) NSMutableArray *privateItemsBelow50;
@property (nonatomic) NSMutableArray *privateItemsAbove50;

@end

@implementation BNRItemStore

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

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
    
    if (item.valueInDollars <= 50) {
        [self.privateItemsBelow50 removeObjectIdenticalTo:item];
    } else if (item.valueInDollars > 50) {
        [self.privateItemsAbove50 removeObjectIdenticalTo:item];
    }
}

- (void)switchItem:(BNRItem *)item
{
    if (item.valueInDollars <= 50) {
        [self.privateItemsBelow50 removeObjectIdenticalTo:item];
        [self.privateItemsAbove50 addObject:item];
    } else if (item.valueInDollars > 50) {
        [self.privateItemsAbove50 removeObjectIdenticalTo:item];
        [self.privateItemsBelow50 addObject:item];
    }
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
        NSString *path = [self itemArchivePath];
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        _privateItemsBelow50 = [[NSMutableArray alloc] init];
        _privateItemsAbove50 = [[NSMutableArray alloc] init];
        
        if (!_privateItems) {
            _privateItems = [[NSMutableArray alloc] init];
        }
        
        if (_privateItems) {
            for (BNRItem *item in _privateItems) {
                if (item.valueInDollars <= 50) {
                    [self.privateItemsBelow50 addObject:item];
                } else if (item.valueInDollars > 50) {
                    [self.privateItemsAbove50 addObject:item];
                }
            }
        } // end if
        
    }
    
    return self;
}

- (NSArray *)allItems
{
    return self.privateItems;
}

- (NSArray *)itemsAbove50
{
    return self.privateItemsAbove50;
}

- (NSArray *)itemsBelow50
{
    return self.privateItemsBelow50;
}

- (BNRItem *)createItem
{
    BNRItem *item = [[BNRItem alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    item.valueInDollars = [[defaults objectForKey:BNRNextItemValuePrefsKey] intValue];
    item.itemName = [defaults valueForKey:BNRNextItemNamePrefsKey];
    
    [self.privateItems addObject:item];
    
    if (item.valueInDollars <= 50) {
        [self.privateItemsBelow50 addObject:item];
    } else if (item.valueInDollars > 50) {
        [self.privateItemsAbove50 addObject:item];
    }
    
    return item;
}

@end
