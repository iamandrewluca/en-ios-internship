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
    self.layer.cornerRadius = 10.0f;
    _border = [CAShapeLayer layer];
    _border.strokeColor = [UIColor lightGrayColor].CGColor;
    _border.fillColor = nil;
    _border.lineDashPattern = @[@4, @2];
    [self.layer addSublayer:_border];
}

- (void)layoutSubviews
{
    _border.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10.0f].CGPath;
    _border.frame = self.bounds;
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
    
    [UIView animateWithDuration:timeInterval animations:^{
        // swap without third )
        self.addLabel.alpha += self.doneLabel.alpha;
        self.doneLabel.alpha = self.addLabel.alpha - self.doneLabel.alpha;
        self.addLabel.alpha -= self.doneLabel.alpha;
    }];
}

@end