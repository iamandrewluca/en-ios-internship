//
//  Notebook.h
//  ENote
//
//  Created by Andrei Luca on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface Notebook : Item

@property (nonatomic, readonly) NSArray *notesIDs;

- (void)addNoteID:(NSString *)ID;
- (void)removeNoteID:(NSString *)ID;

@end
