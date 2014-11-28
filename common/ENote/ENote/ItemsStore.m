//
//  ItemsStore.m
//  ENote
//
//  Created by Andrei Luca on 11/28/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "ItemsStore.h"
#import "ENoteCommons.h"
#import "Item.h"

@implementation ItemsStore

- (instancetype)init {
    return [self initInFolder:[[ENoteCommons shared] documentDirectory]];
}

- (instancetype)initInFolder:(NSString *)folder {
    
    self = [super init];
    
    if (self) {
        _storePath = folder;
        
        [self loadItems];
    }
    
    return self;
}

- (void)addItem:(Item *)item {
    [super addItem:item];
    [self saveItem:item];
}

- (void)saveItem:(Item *)item {
    
    NSString *itemPath = [NSString stringWithFormat:@"%@/%@", _storePath, item.ID];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:itemPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    
    NSData *itemData = [NSJSONSerialization dataWithJSONObject:[item dictionaryRepresentation]
                                                            options:0
                                                              error:nil];
    
    NSString *indexPath = [NSString stringWithFormat:@"%@/%@", itemPath, [[ENoteCommons shared] indexFile]];
    
    [[NSFileManager defaultManager] createFileAtPath:indexPath contents:itemData attributes:nil];
}

- (void)removeItem:(Item *)item {
    [super removeItem:item];
    
    NSString *itemPath = [NSString stringWithFormat:@"%@/%@", _storePath, item.ID];
    
    [[NSFileManager defaultManager] removeItemAtPath:itemPath error:nil];
}

- (NSArray *)getValidItemsPaths {
    
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

- (void)loadItems {
    
    NSArray *itemPaths = [self getValidItemsPaths];
    
    for (NSString *itemPath in itemPaths) {
        
        NSString *indexPath = [NSString stringWithFormat:@"%@/%@/%@", _storePath, itemPath, [[ENoteCommons shared] indexFile]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:indexPath]) {
            
            NSData *itemData = [[NSFileManager defaultManager] contentsAtPath:indexPath];
            NSDictionary *itemDictionary = [NSJSONSerialization JSONObjectWithData:itemData options:0 error:nil];
            [super addItem:[self itemFromDictionary:itemDictionary]];
        }
    }
}

@end
