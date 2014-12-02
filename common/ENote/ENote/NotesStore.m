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

@interface NotesStore ()

@property (nonatomic) NSMutableArray *allPrivateNotes;

@end

@implementation NotesStore

+ (instancetype)sharedStore {
    
    static NotesStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[TagsStore sharedStore]" userInfo:nil];
}

- (instancetype)initPrivate {
    
    self = [super init];
    
    if (self) {
        _allPrivateNotes = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (NSArray *)allNotes {
    return _allPrivateNotes;
}

- (void)saveNote:(Note *)note {
    
    NSString *notePath = [NSString stringWithFormat:@"%@/%@/%@", [[ENoteCommons shared] documentDirectory], note.notebookID, note.ID];
    
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

- (void)saveNoteWithID:(NSString *)ID {
    for (Note *note in _allPrivateNotes) {
        if ([ID isEqualToString:note.ID]) {
            [self saveNote:note];
            return;
        }
    }
}

- (void)addNote:(Note *)note {
    [_allPrivateNotes addObject:note];
}

- (Note *)createNoteWithName:(NSString *)name forNotebook:(Notebook *)notebook {
    return [self createNoteWithName:name forNotebookID:notebook.ID];
}

- (Note *)createNoteWithName:(NSString *)name forNotebookID:(NSString *)ID {
    Note *note = [[Note alloc] initWithName:name forNotebookID:ID];
    [self addNote:note];
    [self saveNote:note];
    return note;
}

- (void)addNoteWithDictionary:(NSDictionary *)dictionary {
    [self addNote:[[Note alloc] initWithDictionary:dictionary]];
}

- (void)removeNote:(Note *)note {
    
    Notebook *notebook = [[NotebooksStore sharedStore] notebookWithID:note.notebookID];
    [notebook removeNoteID:note.ID];
    [[NotebooksStore sharedStore] saveNotebook:notebook];
    
    NSString *itemPath = [NSString stringWithFormat:@"%@/%@/%@", [[ENoteCommons shared] documentDirectory], notebook.ID, note.ID];
    
    [[NSFileManager defaultManager] removeItemAtPath:itemPath error:nil];
    
    [_allPrivateNotes removeObject:notebook];
}

- (void)removeNoteWithID:(NSString *)ID {
    for (Note *note in _allPrivateNotes) {
        if ([ID isEqualToString:note.ID]) {
            [self removeNote:note];
            return;
        }
    }
}

- (Note *)noteWithID:(NSString *)ID {
    for (Note *note in _allPrivateNotes) {
        if ([ID isEqualToString:note.ID]) {
            return note;
        }
    }
    
    return nil;
}

- (void)loadNotesForNotebook:(Notebook *)notebook {
    
    NSArray *itemPaths = [[ENoteCommons shared] getValidItemsPathsInFolder:[NSString stringWithFormat:@"%@/%@", [[ENoteCommons shared] documentDirectory], notebook.ID]];
    
    for (NSString *itemPath in itemPaths) {
        
        NSString *indexPath = [NSString stringWithFormat:@"%@/%@/%@", [[ENoteCommons shared] documentDirectory], itemPath, [[ENoteCommons shared] indexFile]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:indexPath]) {
            
            NSData *itemData = [[NSFileManager defaultManager] contentsAtPath:indexPath];
            NSDictionary *itemDictionary = [NSJSONSerialization JSONObjectWithData:itemData options:NSJSONReadingMutableContainers error:nil];
            [self addNoteWithDictionary:itemDictionary];
        }
    }
}

@end
