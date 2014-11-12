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
    
    Note *note = [[Note alloc] initWithText:text];
    
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
    return _privateNotes;
}

@end
