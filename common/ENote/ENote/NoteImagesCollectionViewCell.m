//
//  NoteImagesCollectionViewCell.m
//  ENote
//
//  Created by Andrei Luca on 12/22/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NoteImagesCollectionViewCell.h"

@implementation NoteImagesCollectionViewCell

- (void)awakeFromNib
{
    CAShapeLayer *mask = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_deleteButton.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(10.0f, 10.0f)];
    mask.path = path.CGPath;
    self.deleteButton.layer.mask = mask;
    self.layer.cornerRadius = 10.0f;
}

- (IBAction)deletePressed:(id)sender
{
    [_delegate deleteButtonPressedInCell:self];
}

@end
