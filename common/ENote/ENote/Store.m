//
//  Store.m
//  ENote
//
//  Created by Andrei Luca on 11/25/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "Store.h"
#import "StoreItem.h"
#import "ENoteCommons.h"

@interface Store ()

@property (nonatomic, readonly) NSMutableArray *allPrivateStoreItems;

@end

@implementation Store

#pragma mark Initialization

- (instancetype)init {
    return [self initInFolder:[[ENoteCommons shared] documentDirectory]];
}

- (instancetype)initInFolder:(NSString *)folder {
    
    self = [super init];
    
    if (self) {
        
        _allPrivateStoreItems = [[NSMutableArray alloc] init];
        _storePath = folder;
        
        [self loadStoreItems];
    }
    
    return self;
}

#pragma mark StoreItem Creation

- (StoreItem *)createStoreItem {
    return [self createStoreItemWithName:@"StoreItem Sample"];
}

- (StoreItem *)createStoreItemWithName:(NSString *)name {
    
    StoreItem *storeItem = [self createStoreItemWithName:name atDate:[NSDate date] andFolder:[[NSUUID UUID] UUIDString]];
    
    [self saveStoreItem:storeItem];
    
    return storeItem;
}

- (StoreItem *)createStoreItemWithDictionary:(NSDictionary *)dictionary {
    return [self createStoreItemWithName:dictionary[@"name"]
                                  atDate:[NSDate dateWithTimeIntervalSince1970:[dictionary[@"dateCreated"] doubleValue]]
                               andFolder:dictionary[@"itemFolder"]];
}

- (StoreItem *)createStoreItemWithName:(NSString *)name atDate:(NSDate *)date andFolder:(NSString *)folder {
    
    StoreItem *storeItem = [[StoreItem alloc] initWithName:name atDate:date andFolder:folder];
    
    [_allPrivateStoreItems addObject:storeItem];
    
    return storeItem;
}

#pragma mark StoreItem Related

- (NSArray *)allStoreItems {
    return _allPrivateStoreItems;
}

- (void)removeStoreItem:(StoreItem *)storeItem {
    
    NSString *storeItemPath = [NSString stringWithFormat:@"%@/%@", _storePath, storeItem.itemFolder];
    
    [[NSFileManager defaultManager] removeItemAtPath:storeItemPath error:nil];
    
    [_allPrivateStoreItems removeObject:storeItem];
}

- (NSArray *)getValidStoreItemsPaths {
    
    NSArray *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_storePath error:nil];
    NSMutableArray *allPaths = [NSMutableArray arrayWithArray:paths];

    NSString *pattern = @"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    for (int i = 0; i < allPaths.count; i++) {
        
        NSString *path = allPaths[i];
        NSUInteger count = [regex numberOfMatchesInString:path options:0 range:NSMakeRange(0, path.length)];
        
        if (count == 0) {
            [allPaths removeObject:path];
        }
    }
    
    return allPaths;
}

- (void)loadStoreItems {
    
    NSArray *storeItemsPaths = [self getValidStoreItemsPaths];
    
    for (NSString *storeItemPath in storeItemsPaths) {
        
        NSString *indexPath = [NSString stringWithFormat:@"%@/%@/%@", _storePath, storeItemPath, [[ENoteCommons shared] indexFile]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:indexPath]) {
            
            NSData *storeItemData = [[NSFileManager defaultManager] contentsAtPath:indexPath];
            NSDictionary *storeItemDictionary = [NSJSONSerialization JSONObjectWithData:storeItemData options:0 error:nil];
            
            [self createStoreItemWithDictionary:storeItemDictionary];
        }
    }
}

- (void)saveStoreItem:(StoreItem *)storeItem {
    
    NSString *storeItemPath = [NSString stringWithFormat:@"%@/%@", _storePath, storeItem.itemFolder];

    [[NSFileManager defaultManager] createDirectoryAtPath:storeItemPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    
    NSData *storeItemData = [NSJSONSerialization dataWithJSONObject:[storeItem dictionaryRepresentation]
                                                            options:0
                                                              error:nil];
    
    NSString *indexPath = [NSString stringWithFormat:@"%@/%@", storeItemPath, [[ENoteCommons shared] indexFile]];
    
    [[NSFileManager defaultManager] createFileAtPath:indexPath contents:storeItemData attributes:nil];
}

- (void)renameStoreItem:(StoreItem *)storeItem withName:(NSString *)name {
    
    storeItem.name = name;
    
    [self saveStoreItem:storeItem];
}

@end
