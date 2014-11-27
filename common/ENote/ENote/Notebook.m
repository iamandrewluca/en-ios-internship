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

- (instancetype)initWithName:(NSString *)name {
    
    self = [super initWithName:name];
    
    if (self) {
        _notesStore = [[NotesStore alloc] initInFolder:[NSString stringWithFormat:@"%@/%@", [[ENoteCommons shared] documentDirectory], self.itemFolder]];
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        _notesStore = [[NotesStore alloc] initInFolder:[NSString stringWithFormat:@"%@/%@", [[ENoteCommons shared] documentDirectory], dictionary[@"itemFolder"]]];
    }
    
    return self;
}

@end
