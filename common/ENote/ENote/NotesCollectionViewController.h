//
//  NotesCollectionViewController.h
//  ENote
//
//  Created by iboicenco on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NotesStore;

@interface NotesCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NotesStore *notesStore;
@property (nonatomic) BOOL noteWasDeleted;

@end
