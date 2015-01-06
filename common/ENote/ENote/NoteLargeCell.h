//
//  NoteLargeCell.h
//  ENote
//
//  Created by Andrei Luca on 1/6/15.
//  Copyright (c) 2015 Endava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteCell.h"

@interface NoteLargeCell : NoteCell

@property (weak, nonatomic) IBOutlet UILabel *noteDescription;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end
