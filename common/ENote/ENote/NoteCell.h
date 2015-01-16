//
//  NoteCell.h
//  ENote
//
//  Created by iboicenco on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checked;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;

- (void)setImage:(UIImage *)image;

@end
