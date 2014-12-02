//
//  NotesCollectionViewController.h
//  ENote
//
//  Created by iboicenco on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Notebook;
@class NotesStore;

@interface NotesCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>
{
    CGPoint dragStartPt;
    bool dragging;
    
    NSMutableDictionary *selectedIdx;
}

@property (nonatomic) Notebook *notebook;

@end
