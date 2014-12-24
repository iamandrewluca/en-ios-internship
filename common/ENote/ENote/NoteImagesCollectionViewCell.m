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
    _deleteButton.alpha = 0.0f;
    _thumbCheck.alpha = 0.0f;
    [_delegate deleteButtonPressedInCell:self];
}

- (void)setEditing:(BOOL)editing
{
    [self setEditing:editing animated:NO];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    _editing = editing;
    
    NSTimeInterval timeInterval = 0.0f;
    
    if (animated) {
        timeInterval = 0.2f;
    }
    
    CGFloat finalAlpha = 0.0f;
    
    if (editing) {
        finalAlpha = 1.0f;
    }
    
    [UIView animateWithDuration:timeInterval animations:^{
        self.deleteButton.alpha = finalAlpha;
        self.thumbCheck.alpha = finalAlpha;
    }];
}

- (void)checkCell
{
    self.thumbCheck.image = [UIImage imageNamed:@"checked"];
}

- (void)uncheckCell
{
    self.thumbCheck.image = [UIImage imageNamed:@"unchecked"];
}

@end
