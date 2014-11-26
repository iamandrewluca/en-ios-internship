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

- (instancetype)initWithName:(NSString *)name atDate:(NSDate *)date andFolder:(NSString *)folder {
    
    self = [super initWithName:name atDate:date andFolder:folder];
    
    if (self) {
        _notesStore = [[NotesStore alloc] initInNotebookFolder:folder];        
    }
    
    return self;
}

@end
