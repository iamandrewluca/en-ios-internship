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
    
    self = [super init];
    
    if (self) {
        
        _name = name;
        _notebookFolder = [[NSUUID UUID] UUIDString];
        _dateCreated = [NSDate date];
        _notes = [[NotesStore alloc] init];
        
        for (int i = 0; i < rand() % (999 - 0) + 0; i++) {
            [_notes createNote];
        }
        
    }
    
    return self;
}

@end
