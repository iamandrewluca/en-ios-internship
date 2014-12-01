//
//  NotebooksStore.m
//  ENote
//
//  Created by Andrei Luca on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotebooksStore.h"
#import "Notebook.h"
#import "NotesStore.h"
#import "ENoteCommons.h"
#import "TagsStore.h"


@interface NotebooksStore ()

@property (nonatomic) NSMutableDictionary *notesStores;

@end

@implementation NotebooksStore

- (NSArray *)allNotebooks {
    return [self allItems];
}

+ (instancetype)sharedStore {
    
    static NotebooksStore *sharedStore = nil;
    
    if (!sharedStore) {
        
        sharedStore = [[NotebooksStore alloc] initPrivate];
        
    }
    
    return sharedStore;
}

- (instancetype)initPrivate {
    return [super init];
}

- (NotesStore *)storeForNotebook:(Notebook *)notebook {
    return [_notesStores valueForKey:notebook.ID];
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[NotebooksStore sharedStore]" userInfo:nil];
}

- (instancetype)initInFolder:(NSString *)folder {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[NotebooksStore sharedStore]" userInfo:nil];
}

- (Item *)itemFromDictionary:(NSDictionary *)dictionary {
    Notebook *notebook = [[Notebook alloc] initWithDictionary:dictionary];
    [self addNotesStoreForNotebook:notebook];
    return notebook;
}

- (void)addNotebook:(Notebook *)notebook {
    [self addItem:notebook];
    [self addNotesStoreForNotebook:notebook];
}

- (void)removeNotebook:(Notebook *)notebook {
    [self removeItem:notebook];
    [_notesStores removeObjectForKey:notebook.ID];
}

- (void)addNotesStoreForNotebook:(Notebook *)notebook {
    NotesStore *notesStore = [[NotesStore alloc] initInFolder:[NSString stringWithFormat:@"%@/%@", [[ENoteCommons shared] documentDirectory], notebook.ID]];
    [_notesStores setValue:notesStore forKey:notebook.ID];
}

- (void)saveNotebook:(Notebook *)notebook {
    [self saveItem:notebook];
}

@end
