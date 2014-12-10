//
//  AllTagsCollectionViewController.m
//  ENote
//
//  Created by Andrei Luca on 12/10/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "AllTagsCollectionViewController.h"
#import "TagCollectionViewCell.h"
#import "TagsStore.h"

@interface AllTagsCollectionViewController () <UICollectionViewDelegateFlowLayout, TagCellDelegate>

@end

@implementation AllTagsCollectionViewController
{
    TagCollectionViewCell *_sizingCell;
}

static NSString * const reuseIdentifier = @"TagCell";

- (void)buttonPressedInCell:(TagCollectionViewCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    Tag *tag = [[[TagsStore sharedStore] allTags] objectAtIndex:indexPath.row];
    
    [[TagsStore sharedStore] removeTag:tag];
    
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    _sizingCell.label.text = [[[[TagsStore sharedStore] allTags] objectAtIndex:indexPath.row] name];
    
    // return size it will take from default _sizingCell
    return [_sizingCell systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundPattern"]];
    
    UINib *nib = [UINib nibWithNibName:@"TagCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    
    _sizingCell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[TagsStore sharedStore] allTags] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.label.text = [[[[TagsStore sharedStore] allTags] objectAtIndex:indexPath.row] name];
    cell.delegate = self;
    
    return cell;
}

@end
