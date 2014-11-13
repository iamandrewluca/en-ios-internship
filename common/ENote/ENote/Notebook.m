//
//  Notebook.m
//  ENote
//
//  Created by Andrei Luca on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "Notebook.h"
#import "NotesStore.h"

@implementation Notebook

- (instancetype)init {
    return [self initWithName:@"Sample Notebook"];
}

- (instancetype)initWithName:(NSString *)name {
    return [self initWithName:name atDate:[NSDate date] andFolder:[[NSUUID UUID] UUIDString]];
}

- (instancetype)initWithName:(NSString *)name atDate:(NSDate *)date andFolder:(NSString *)folder {
    
    self = [super init];
    
    if (self) {
        
        _name = name;
        _notebookFolder = folder;
        _dateCreated = date;
        _notes = [[NotesStore alloc] init];
        
        for (int i = 0; i < rand() % (10 - 0) + 0; i++) {
            [_notes createNote];
        }
        
    }
    
    return self;
}

@end
