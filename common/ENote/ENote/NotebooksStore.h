//
//  NotebooksStore.h
//  ENote
//
//  Created by Andrei Luca on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemsStore.h"

@class Notebook;
@class NotesStore;

@interface NotebooksStore : ItemsStore

- (NSArray *)allNotebooks;
- (void)addNotebook:(Notebook *)notebook;
- (void)removeNotebook:(Notebook *)notebook;
- (void)saveNotebook:(Notebook *)notebook;
- (NotesStore *)storeForNotebook:(Notebook *)notebook;

+ (instancetype)sharedStore;

@end
