//
//  AddTagsViewController.h
//  ENote
//
//  Created by Andrei Luca on 12/19/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "NotesStore.h"
#import "NoteTagsCollectionViewController.h"

@interface AddTagsViewController : UIViewController

@property (nonatomic) NotesStore *notesStore;
@property (nonatomic) Note *note;
@property (nonatomic) NoteTagsCollectionViewController *pctrl;

@end
