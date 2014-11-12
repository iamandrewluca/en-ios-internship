//
//  NotesStore.h
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Note;

@interface NotesStore : NSObject

@property (nonatomic) NSArray *allNotes;

- (Note *)createNote;
- (Note *)createNoteWithText:(NSString *)text;
- (void)removeNote:(Note *)note;

@end
