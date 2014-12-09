//
//  TagCollectionViewCell.h
//  CustomCollectionViewLayout
//
//  Created by Oliver Drobnik on 30.08.13.
//  Copyright (c) 2013 Cocoanetics. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TagCollectionViewCell;

@protocol TagCellDelegate <NSObject>
@optional
- (void)buttonPressed:(UIButton *)button inCell:(TagCollectionViewCell *)cell;
@end

@interface TagCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) id<TagCellDelegate> delegate;

@property (nonatomic, weak) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *container;

@end
