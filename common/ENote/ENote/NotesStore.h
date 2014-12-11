//
//  NotesStore.h
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Note;
@class Notebook;

@interface NotesStore : NSObject

@property (nonatomic, readonly) NSArray *allNotes;
@property (nonatomic, weak) Notebook *notebook;

- (instancetype)initWithNotebook:(Notebook *)notebook;
- (void)addNote:(Note *)note;
- (void)removeNote:(Note *)note;
- (void)removeNoteWithID:(NSString *)ID;
- (void)saveNote:(Note *)note;
- (void)saveNoteWithID:(NSString *)ID;
- (Note *)createNoteWithName:(NSString *)name;
- (Note *)noteWithID:(NSString *)ID;

- (void)addImage:(UIImage *)image forNote:(Note *)note;
- (void)removeImageForNote:(Note *)note;

@end
