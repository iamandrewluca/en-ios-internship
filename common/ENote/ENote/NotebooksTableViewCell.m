//
//  NotebooksTableViewCell.m
//  ENote
//
//  Created by Andrei Luca on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotebooksTableViewCell.h"

@interface NotebooksTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *notesNumberContainer;
@end

@implementation NotebooksTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _notesNumberContainer.layer.cornerRadius = 10.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
