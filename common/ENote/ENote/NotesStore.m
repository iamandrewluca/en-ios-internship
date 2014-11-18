//
//  NotesStore.m
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotesStore.h"
#import "Note.h"
#import "NSObject+NSDictionaryRepresentation.h"
#import "ENoteCommons.h"

@interface NotesStore ()

@property (nonatomic) NSMutableArray *privateNotes;

@property (nonatomic, readonly, copy) NSString *notebookFolder;

@end

@implementation NotesStore

- (void)saveNotes {
    
    NSMutableArray *notes = [[NSMutableArray alloc] init];
    
    for (Note *note in _privateNotes) {
        [notes addObject:[note dictionaryRepresentation]];
    }
    
    NSMutableDictionary *notesDictionary = [[NSMutableDictionary alloc] init];
    
    [notesDictionary setValue:notes forKey:@"notes"];
    
    NSData *notesData = [NSJSONSerialization dataWithJSONObject:notesDictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    [[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"%@/%@/%@", [[ENoteCommons shared] documentDirectory], _notebookFolder, [[ENoteCommons shared] indexFile]] contents:notesData attributes:nil];
    
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
    
    NSString *notePath = [NSString stringWithFormat:@"%@/%@/%@", [[ENoteCommons shared] documentDirectory], _notebookFolder, note.noteFolder];
    
    NSLog(@"%@", _notebookFolder);
    
    [[NSFileManager defaultManager] createDirectoryAtPath:notePath
                              withIntermediateDirectories:NO
                                               attributes:nil
                                                    error:nil];
    
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
        
        NSString *indexPath = [NSString stringWithFormat:@"%@/%@/%@", [[ENoteCommons shared] documentDirectory], notebookFolder, [[ENoteCommons shared] indexFile]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:indexPath]) {
            
            NSData *notesData = [[NSFileManager defaultManager] contentsAtPath:indexPath];
            NSDictionary *notesDictionary = [NSJSONSerialization JSONObjectWithData:notesData options:NSJSONReadingMutableContainers error:nil];
            
            NSMutableArray *notes = notesDictionary[@"notes"];
            
            for (int i = 0; i < [notes count]; i++) {
                [self createNoteWithDictionary:notes[i]];
            }
        }
        
        for (int i = 0; i < rand() % 10; i++) {
            [self createNoteWithName:[NSString stringWithFormat:@"Note %d", i]];
        }
        
    }
    
    return self;
}

- (NSArray *)allNotes {
    return self.privateNotes;
}

@end
