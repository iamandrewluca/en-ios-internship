//
//  NotesCollectionViewController.h
//  ENote
//
//  Created by iboicenco on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notebook.h"
#import "Note.h"

@interface NotesCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>
{
    CGPoint dragStartPt;
    bool dragging;
    
    NSMutableDictionary *selectedIdx;
}

@property (nonatomic) Notebook *notebook;
@property (nonatomic) Note *note;

@end
