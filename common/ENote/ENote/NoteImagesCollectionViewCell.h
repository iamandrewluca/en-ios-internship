//
//  NoteImagesCollectionViewCell.h
//  ENote
//
//  Created by Andrei Luca on 12/22/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoteImagesCollectionViewCell;

@protocol NoteImagesCollectionViewCellDelegate <NSObject>

- (void)deleteButtonPressedInCell:(NoteImagesCollectionViewCell *)cell;

@end

@interface NoteImagesCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbImage;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIImageView *thumbCheck;
@property (nonatomic, assign) id<NoteImagesCollectionViewCellDelegate> delegate;
@property (nonatomic, getter=isEditing) BOOL editing;

- (void)setEditing:(BOOL)editing animated:(BOOL)animated;
- (void)checkCell;
- (void)uncheckCell;

@end


