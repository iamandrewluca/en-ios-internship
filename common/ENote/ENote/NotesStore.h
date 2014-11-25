//
//  NotesStore.h
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Store.h"

@class Note;

@interface NotesStore : Store

@property (nonatomic) NSArray *allNotes;

- (instancetype)initInNotebookFolder:(NSString *)notebookFolder;
- (Note *)createNote;
- (Note *)createNoteWithName:(NSString *)name;
- (Note *)createNoteWithName:(NSString *)name withText:(NSString *)text atDate:(NSDate *)date andFolder:(NSString *)folder;
- (void)removeNote:(Note *)note;

@end
