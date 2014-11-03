//
//  BNRItemCell.h
//  BNRHomepwner
//
//  Created by Andrei Luca on 10/22/14.
//  Copyright (c) 2014 Andrei Luca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNRItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (nonatomic, copy) void (^actionBlock)(void);

@end
