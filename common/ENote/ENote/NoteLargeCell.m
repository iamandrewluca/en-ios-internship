//
//  NoteLargeCell.m
//  ENote
//
//  Created by Andrei Luca on 1/6/15.
//  Copyright (c) 2015 Endava. All rights reserved.
//

#import "NoteLargeCell.h"

@implementation NoteLargeCell

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
    self.checked.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.checked.tintColor = [UIColor blackColor];
}

@end
