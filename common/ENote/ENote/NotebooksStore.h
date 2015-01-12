//
//  NotebooksStore.h
//  ENote
//
//  Created by Andrei Luca on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Notebook;
@class NotesStore;

@interface NotebooksStore : NSObject

@property (nonatomic, readonly) NSArray *allNotebooks;

- (void)removeNotebook:(Notebook *)notebook;
- (void)removeNotebookWithID:(NSString *)ID;
- (void)saveNotebook:(Notebook *)notebook;
- (void)saveNotebookWithID:(NSString *)ID;
- (Notebook *)createNotebookWithName:(NSString *)name;
- (Notebook *)notebookWithID:(NSString *)ID;
- (NotesStore *)notesStoreForNotebook:(Notebook *)notebook;
- (NotesStore *)notesStoreForNotebookID:(NSString *)ID;

+ (instancetype)sharedStore;

@end
