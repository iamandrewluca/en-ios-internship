//
//  AllNotesTVCell.m
//  ENote
//
//  Created by Andrei Luca on 12/19/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "AllNotesTVCell.h"

static NSString *const kNoteCell = @"NoteCell";

@implementation AllNotesTVCell

- (void)awakeFromNib
{
    UINib *nib = [UINib nibWithNibName:kNoteCell bundle:nil];
    [_notesCollectionView registerNib:nib forCellWithReuseIdentifier:kNoteCell];
    
}

@end
