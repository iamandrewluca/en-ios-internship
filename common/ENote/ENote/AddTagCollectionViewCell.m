//
//  AddTagCollectionViewCell.m
//  ENote
//
//  Created by Andrei Luca on 12/15/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "AddTagCollectionViewCell.h"

@interface AddTagCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation AddTagCollectionViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.backView.layer.cornerRadius = 12.0f;
    self.backView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.backView.layer.borderWidth = 1.0;
    
    self.addButton.transform = CGAffineTransformRotate(self.addButton.transform, M_PI_4);
    
    UIImage *image = [[UIImage imageNamed:@"Remove"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_addButton setBackgroundImage:image forState:UIControlStateNormal];
    _addButton.tintColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1];
}

@end