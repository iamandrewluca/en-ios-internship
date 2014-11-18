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
        
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@", [[ENoteCommons shared] documentDirectory], _notebookFolder]
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];

        _dateCreated = date;
        _notesStore = [[NotesStore alloc] initInNotebookFolder:_notebookFolder];
        
        
        
        for (int i = 0; i < rand() % (10 - 0) + 0; i++) {
            [_notesStore createNote];
        }
        
    }
    
    return self;
}

- (void)dealloc {    
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@", [[ENoteCommons shared] documentDirectory], _notebookFolder] error:nil];
}

@end
