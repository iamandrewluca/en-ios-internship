//
//  NotebooksTableViewCell.h
//  ENote
//
//  Created by Andrei Luca on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotebooksTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *datelabel;
@property (weak, nonatomic) IBOutlet UILabel *notesNumberLabel;
@end
