//
//  NotesStore.h
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemsStore.h"
#import "Notebook.h"

@interface NotesStore : ItemsStore

@property (nonatomic, weak) Notebook *notebook;

@end
