//
//  NotesStore.m
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotesStore.h"

@interface NotesStore ()

@property (nonatomic) NSMutableArray *privateNotes;

@end

@implementation NotesStore

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
