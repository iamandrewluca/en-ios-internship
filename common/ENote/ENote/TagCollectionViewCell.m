//
//  TagCollectionViewCell.m
//  CustomCollectionViewLayout
//
//  Created by Oliver Drobnik on 30.08.13.
//  Copyright (c) 2013 Cocoanetics. All rights reserved.
//

#import "TagCollectionViewCell.h"

@interface TagCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *container;

@end

@implementation TagCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.container.layer.cornerRadius = 12.0f;
}

- (IBAction)buttonPressed:(id)sender {
    [_delegate buttonPressedInCell:self];
}

- (void)setCanBeDeleted:(BOOL)canBeDeleted
{
    _canBeDeleted = canBeDeleted;
    
    // why can't set it static?
    CGAffineTransform defaultButtonRotation = CGAffineTransformMakeRotation(0);
    
    if (_canBeDeleted) {
        _deleteButton.tintColor = [UIColor redColor];
        _deleteButton.transform = CGAffineTransformRotate(defaultButtonRotation, M_PI / 4.0f);
    } else {
        _deleteButton.tintColor = [UIColor colorWithRed:0.0f green:0.478431f blue:1.0f alpha:1.0f];
        _deleteButton.transform = CGAffineTransformRotate(defaultButtonRotation, 0.0f);
    }
}

@end
