//
//  AllNotesTVCell.h
//  ENote
//
//  Created by Andrei Luca on 12/19/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllNotesTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *notebookLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *notesCollectionView;

@end
