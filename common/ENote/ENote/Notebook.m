//
//  Notebook.m
//  ENote
//
//  Created by Andrei Luca on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "Notebook.h"
#import "NotesStore.h"
#import "ENoteCommons.h"

@implementation Notebook

- (NSDictionary *)dictionaryRepresentation {
    return @{
             @"name": _name,
             @"notebookFolder": _notebookFolder,
             @"dateCreated": [NSString stringWithFormat:@"%.0f", [_dateCreated timeIntervalSince1970]]
             };
}

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
        _notesStore = [[NotesStore alloc] initInNotebookFolder:folder];
        
    }
    
    return self;
}

@end
