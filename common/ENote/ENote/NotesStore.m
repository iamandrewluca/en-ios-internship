//
//  NotesStore.m
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotesStore.h"
#import "Note.h"

@interface NotesStore ()

@property (nonatomic) NSMutableArray *privateNotes;

@end

@implementation NotesStore

- (void)removeNote:(Note *)note {
    [self.privateNotes removeObject:note];    
}

- (Note *)createNote {
    return [self createNoteWithText:@"Just a Note"];
}

- (Note *)createNoteWithText:(NSString *)text {
    return [self createNoteWithText:text atDate:[NSDate date] andFolder:[[NSUUID UUID] UUIDString]];
}

- (Note *)createNoteWithText:(NSString *)text atDate:(NSDate *)date andFolder:(NSString *)folder {
    
    Note *note = [[Note alloc] initWithText:text atDate:date andFolder:folder];
    
    [self.privateNotes addObject:note];
    
    return note;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        _privateNotes = [[NSMutableArray alloc] init];
        
    }
    
    return self;
}

- (NSArray *)allNotes {
    return self.privateNotes;
}

@end
