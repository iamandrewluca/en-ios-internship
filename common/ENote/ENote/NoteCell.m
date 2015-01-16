//
//  NoteCell.m
//  ENote
//
//  Created by iboicenco on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NoteCell.h"

@implementation NoteCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.layer setMasksToBounds:NO];
    
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.layer.borderWidth = 1.5f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 4.0f;
    self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.layer.shadowOpacity = 0.5f;
}

- (void)setImage:(UIImage *)image
{
    self.checked.image = image;
}

@end
