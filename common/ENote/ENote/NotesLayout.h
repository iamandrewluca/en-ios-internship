//
//  NotesLayout.h
//  ENote
//
//  Created by iboicenco on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesLayout : UICollectionViewLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic) CGFloat spacingHeight;

@end
