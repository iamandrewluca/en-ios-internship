//
//  NotebooksStore.m
//  ENote
//
//  Created by Andrei Luca on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotebooksStore.h"
#import "ENoteCommons.h"

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

@end
