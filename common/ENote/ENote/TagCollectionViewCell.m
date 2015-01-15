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
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation TagCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.container.layer.cornerRadius = 12.0f;
    self.container.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.container.layer.borderWidth = 1.0;
    
    UIImage *image = [[UIImage imageNamed:@"Remove"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [_deleteButton setBackgroundImage:image forState:UIControlStateNormal];
    _deleteButton.tintColor = [UIColor redColor];
}

- (IBAction)buttonPressed:(id)sender
{
    [_delegate buttonPressedInCell:self];
}

@end
