//
//  Notebook.h
//  ENote
//
//  Created by Andrei Luca on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreItem.h"
#import "NotesStore.h"

@class Store;

@interface Notebook : StoreItem

@property (nonatomic) NotesStore *notesStore;

@end
