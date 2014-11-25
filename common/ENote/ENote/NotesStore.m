//
//  NotesStore.m
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotesStore.h"
#import "Note.h"
#import "ENoteCommons.h"

@interface NotesStore ()

@property (nonatomic) NSMutableArray *privateNotes;

@property (nonatomic, readonly, copy) NSString *notebookFolder;

@end

@implementation NotesStore

- (void)loadNotes {
    
    NSString *notesPath = [NSString stringWithFormat:@"%@/%@", [[ENoteCommons shared] documentDirectory], _notebookFolder];
    
    NSArray *notesPaths = [ENoteCommons getValidPathsAtPath:notesPath];
    
    for (NSString *notePath in notesPaths) {
        
        NSString *indexPath = [NSString stringWithFormat:@"%@/%@/%@", notesPath, notePath, [[ENoteCommons shared] indexFile]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:indexPath]) {
            
            NSData *noteData = [[NSFileManager defaultManager] contentsAtPath:indexPath];
            NSDictionary *noteDictionary = [NSJSONSerialization JSONObjectWithData:noteData options:NSJSONReadingMutableContainers error:nil];
            
            [self createNoteWithDictionary:noteDictionary];
        }
    }
}

- (void)saveNote:(Note *)note {
    
    NSString *notePath = [NSString stringWithFormat:@"%@/%@/%@", [[ENoteCommons shared] documentDirectory], _notebookFolder, note.noteFolder];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:notePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    
    NSData *noteData = [NSJSONSerialization dataWithJSONObject:[note dictionaryRepresentation] options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *indexPath = [NSString stringWithFormat:@"%@/%@", notePath, [[ENoteCommons shared] indexFile]];
    
    [[NSFileManager defaultManager] createFileAtPath:indexPath contents:noteData attributes:nil];
}

- (void)removeNote:(Note *)note {
    
    NSString *notePath = [NSString stringWithFormat:@"%@/%@/%@", [[ENoteCommons shared] documentDirectory], _notebookFolder, note.noteFolder];
    
    [[NSFileManager defaultManager] removeItemAtPath:notePath error:nil];
    
    [self.privateNotes removeObject:note];    
}

- (Note *)createNote {
    return [self createNoteWithName:@"Just a Note"];
}

- (Note *)createNoteWithName:(NSString *)name {
    
    Note *note = [self createNoteWithName:name withText:@"" atDate:[NSDate date] andFolder:[[NSUUID UUID] UUIDString]];
    
    [self saveNote:note];
    
    return note;
}

- (Note *)createNoteWithName:(NSString *)name withText:(NSString *)text atDate:(NSDate *)date andFolder:(NSString *)folder {
    
    Note *note = [[Note alloc] initWithName:name withText:text atDate:date andFolder:folder];
    
    [self.privateNotes addObject:note];
    
    return note;
}

- (Note *)createNoteWithDictionary:(NSDictionary *)dictionary {
    
    Note *note = [self createNoteWithName:dictionary[@"name"]
                                 withText:dictionary[@"text"]
                                   atDate:[NSDate dateWithTimeIntervalSince1970:[dictionary[@"dateCreated"] doubleValue]]
                                andFolder:dictionary[@"noteFolder"]];
    
    return note;
}

- (instancetype)initInNotebookFolder:(NSString *)notebookFolder {
    
    self = [super init];
    
    if (self) {
        
        _privateNotes = [[NSMutableArray alloc] init];
        _notebookFolder = notebookFolder;
        
        [self loadNotes];
    }
    
    return self;
}

- (NSArray *)allNotes {
    return self.privateNotes;
}

@end
