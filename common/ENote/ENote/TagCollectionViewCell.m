//
//  TagCollectionViewCell.m
//  CustomCollectionViewLayout
//
//  Created by Oliver Drobnik on 30.08.13.
//  Copyright (c) 2013 Cocoanetics. All rights reserved.
//

#import "TagCollectionViewCell.h"

@implementation TagCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _deleteButton.transform = CGAffineTransformRotate(_deleteButton.transform, M_PI / 4);
    _deleteButton.tintColor = [UIColor redColor];
    self.container.layer.cornerRadius = 12.0f;

}

- (IBAction)buttonPressed:(id)sender {
    [_delegate buttonPressed:sender inCell:self];
}

@end
