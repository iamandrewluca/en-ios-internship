//
//  AddNoteImageCollectionViewCell.m
//  ENote
//
//  Created by Andrei Luca on 12/22/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "AddNoteImageCollectionViewCell.h"

@interface AddNoteImageCollectionViewCell ()
@property (nonatomic) CAShapeLayer *border;
@end

@implementation AddNoteImageCollectionViewCell

- (void)awakeFromNib
{
    _border = [CAShapeLayer layer];
    _border.strokeColor = [UIColor lightGrayColor].CGColor;
    _border.fillColor = nil;
    _border.lineDashPattern = @[@4, @2];
    [self.layer addSublayer:_border];
}

- (void)layoutSubviews
{
    _border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    _border.frame = self.bounds;
}

@end
