//
//  NoteImagesCollectionViewController.h
//  ENote
//
//  Created by Andrei Luca on 12/22/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "NotesStore.h"

@interface NoteImagesCollectionViewController : UICollectionViewController
@property (nonatomic) NotesStore *notesStore;
@property (nonatomic) Note *note;
@end
