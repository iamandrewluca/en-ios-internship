//
//  NoteTagsCollectionViewController.h
//  ENote
//
//  Created by Andrei Luca on 1/6/15.
//  Copyright (c) 2015 Endava. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Note;
@class NotesStore;

@interface NoteTagsCollectionViewController : UICollectionViewController
@property (nonatomic) Note *note;
@property (nonatomic) NotesStore *notesStore;
@end
