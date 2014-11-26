//
//  NotebooksStore.m
//  ENote
//
//  Created by Andrei Luca on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotebooksStore.h"
#import "ENoteCommons.h"
#import "Notebook.h"

@interface NotebooksStore ()

@end

@implementation NotebooksStore

+ (instancetype)sharedStore {
    
    static NotebooksStore *sharedStore = nil;
    
    if (!sharedStore) {
        
        sharedStore = [[super alloc] initInFolder:[[ENoteCommons shared] documentDirectory]];
        
    }
    
    return  sharedStore;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[NotebooksStore sharedStore]" userInfo:nil];
}


- (StoreItem *)createStoreItemWithName:(NSString *)name atDate:(NSDate *)date andFolder:(NSString *)folder {
    
    Notebook *storeItem = [[Notebook alloc] initWithName:name atDate:date andFolder:folder];
    
    [self.allStoreItems addObject:storeItem];
    
    return storeItem;
}

@end
