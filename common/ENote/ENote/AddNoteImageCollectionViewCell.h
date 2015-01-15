//
//  AddNoteImageCollectionViewCell.h
//  ENote
//
//  Created by Andrei Luca on 12/22/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNoteImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UILabel *doneLabel;
@property (nonatomic, getter=isEditing) BOOL editing;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

@end
