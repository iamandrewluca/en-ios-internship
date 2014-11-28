//
//  NotebooksStore.m
//  ENote
//
//  Created by Andrei Luca on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotebooksStore.h"
#import "Notebook.h"

@interface NotebooksStore ()

@end

@implementation NotebooksStore

+ (instancetype)sharedStore {
    
    static NotebooksStore *sharedStore = nil;
    
    if (!sharedStore) {
        
        sharedStore = [[NotebooksStore alloc] initPrivate];
        
    }
    
    return  sharedStore;
}

- (instancetype)initPrivate {
    
    self = [super init];
    
    if (self) {
        // load notes stores
    }
    
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[NotebooksStore sharedStore]" userInfo:nil];
}

- (instancetype)initInFolder:(NSString *)folder {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[NotebooksStore sharedStore]" userInfo:nil];
}

- (Item *)itemFromDictionary:(NSDictionary *)dictionary {
    return [[Notebook alloc] initWithDictionary:dictionary];
}

- (void)addNotebook:(Notebook *)notebook {
    [self addItem:notebook];
}

- (void)removeNotebook:(Notebook *)notebook {
    [self removeItem:notebook];
}

@end
