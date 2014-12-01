//
//  NotesStore.h
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemsStore.h"

@class Note;

@interface NotesStore : ItemsStore

- (NSArray *)allNotes;
- (void)addNote:(Note *)note;
- (void)removeNote:(Note *)note;
- (void)saveNote:(Note *)note;

@end
