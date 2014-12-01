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

@end

@implementation NotesStore

- (NSArray *)allNotes {
    return [self allItems];
}

- (void)addNote:(Note *)note {
    [self addItem:note];
}

- (void)removeNote:(Note *)note {
    [self removeItem:note];
}

- (void)saveNote:(Note *)note {
    [self saveItem:note];
}

- (Item *)itemFromDictionary:(NSDictionary *)dictionary {
    return [[Note alloc] initWithDictionary:dictionary];
}

@end
