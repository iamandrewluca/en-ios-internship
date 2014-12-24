//
//  NotesStore.m
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotesStore.h"
#import "Note.h"
#import "Notebook.h"
#import "NotebooksStore.h"
#import "ENoteCommons.h"
#import "TagsStore.h"

@interface NotesStore ()

@property (nonatomic) NSMutableArray *allPrivateNotes;

@end

@implementation NotesStore

- (instancetype)initWithNotebook:(Notebook *)notebook
{
    self = [super init];
    
    if (self) {
        _allPrivateNotes = [[NSMutableArray alloc] init];
        _notebook = notebook;
        
        [self loadNotes];
    }
    
    return self;
}

- (NSArray *)allNotes
{
    return _allPrivateNotes;
}

- (void)saveNote:(Note *)note
{
    NSString *notePath = [note path];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:notePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    
    NSData *noteData = [NSJSONSerialization dataWithJSONObject:[note dictionaryRepresentation]
                                                           options:0
                                                             error:nil];
    
    NSString *indexPath = [NSString stringWithFormat:@"%@/%@", notePath, [[ENoteCommons shared] indexFile]];
    
    [[NSFileManager defaultManager] createFileAtPath:indexPath contents:noteData attributes:nil];
}

- (void)saveNoteWithID:(NSString *)ID
{
    for (Note *note in _allPrivateNotes) {
        if ([ID isEqualToString:note.ID]) {
            [self saveNote:note];
            return;
        }
    }
}

- (void)addNote:(Note *)note
{
    [_allPrivateNotes addObject:note];
}

- (Note *)createNoteWithName:(NSString *)name
{
    Note *note = [[Note alloc] initWithName:name forNotebookID:_notebook.ID];
    
    [_notebook addNoteID:note.ID];
    [[NotebooksStore sharedStore] saveNotebook:_notebook];

    [self addNote:note];
    [self saveNote:note];
    return note;
}

- (void)addNoteWithDictionary:(NSDictionary *)dictionary
{
    Note *note = [[Note alloc] initWithDictionary:dictionary];
    [self addNote:note];
}

- (void)removeNote:(Note *)note
{
    [_notebook removeNoteID:note.ID];
    [[NotebooksStore sharedStore] saveNotebook:_notebook];
    
    [[NSFileManager defaultManager] removeItemAtPath:[note path] error:nil];
    
    [_allPrivateNotes removeObject:note];
}

- (void)removeNoteWithID:(NSString *)ID
{
    for (Note *note in _allPrivateNotes) {
        if ([ID isEqualToString:note.ID]) {
            [self removeNote:note];
            return;
        }
    }
}

- (Note *)noteWithID:(NSString *)ID
{
    for (Note *note in _allPrivateNotes) {
        if ([ID isEqualToString:note.ID]) {
            return note;
        }
    }
    
    return nil;
}

- (void)loadNotes
{
    for (NSString *noteID in _notebook.notesIDs) {
        
        NSString *indexPath = [NSString stringWithFormat:@"%@/%@/%@/%@", [[ENoteCommons shared] documentDirectory], _notebook.ID, noteID, [[ENoteCommons shared] indexFile]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:indexPath]) {
            
            NSData *itemData = [[NSFileManager defaultManager] contentsAtPath:indexPath];
            NSDictionary *itemDictionary = [NSJSONSerialization JSONObjectWithData:itemData options:NSJSONReadingMutableContainers error:nil];
            [self addNoteWithDictionary:itemDictionary];
        }
    }
}

@end
