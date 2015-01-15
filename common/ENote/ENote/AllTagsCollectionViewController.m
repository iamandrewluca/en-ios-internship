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
#import "Tag.h"
#import "TagsSectionHeadersCollectionReusableView.h"

static NSString *const kTagCollectionViewCell = @"TagCollectionViewCell";
static NSString *const kTagsSectionHeader = @"TagsSectionHeadersCollectionReusableView";

@interface AllTagsCollectionViewController () <UISearchBarDelegate, UICollectionViewDelegateFlowLayout, TagCellDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSMutableArray *foundTags;

@end

@implementation AllTagsCollectionViewController
{
    TagCollectionViewCell *_sizingCell;
}

- (void)buttonPressedInCell:(TagCollectionViewCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    Tag *tag = nil;

    if ([_foundTags count]) {
        tag = [_foundTags objectAtIndex:indexPath.row];
        [_foundTags removeObject:tag];
    } else {
        NSArray *tags = [[TagsStore sharedStore] tagsForSection:indexPath.section];
        tag = [tags objectAtIndex:indexPath.row];
    }
    
    [[TagsStore sharedStore] removeTag:tag];

    // sdk/api/bug ))
    // http://stackoverflow.com/questions/12611292/uicollectionview-assertion-failure
    if (indexPath.row) {
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } else {
        [_collectionView reloadData];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_foundTags count]) {
        Tag *tag = [_foundTags objectAtIndex:indexPath.row];
        _sizingCell.label.text = tag.name;
    } else {
        NSArray *tags = [[TagsStore sharedStore] tagsForSection:indexPath.section];
        _sizingCell.label.text = [[tags objectAtIndex:indexPath.row] name];
    }
    
    // return size it will take from default _sizingCell
    return [_sizingCell systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundPattern"]];
    
    UINib *headerNib = [UINib nibWithNibName:kTagsSectionHeader bundle:nil];
    [self.collectionView registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kTagsSectionHeader];
    
    UINib *cellNib = [UINib nibWithNibName:kTagCollectionViewCell bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:kTagCollectionViewCell];
    
    _sizingCell = [[cellNib instantiateWithOwner:nil options:nil] objectAtIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([_foundTags count]) {
        return 1;
    } else {
        return [[TagsStore sharedStore] countAvailableSections];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_foundTags count]) {
        return [_foundTags count];
    } else {
        return [[TagsStore sharedStore] countInSection:section];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTagCollectionViewCell forIndexPath:indexPath];
    
    if ([_foundTags count]) {
        Tag *tag = [_foundTags objectAtIndex:indexPath.row];
        cell.label.text = tag.name;
    } else {
        NSArray *tags = [[TagsStore sharedStore] tagsForSection:indexPath.section];
        cell.label.text = [[tags objectAtIndex:indexPath.row] name];
    }
    
    cell.delegate = self;
    
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    BOOL foundTagsLastTime = [_foundTags count] != 0;
    
    _foundTags = [[TagsStore sharedStore] tagsWhichContainText:searchText];
    
    if ([_foundTags count] || ([_foundTags count] == 0 && foundTagsLastTime)) {
        [self.collectionView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    Tag *tag = [[TagsStore sharedStore] getTagWithName:searchBar.text];
    
    if (tag) {
        // animate tag
    } else {
        [[TagsStore sharedStore] createTagWithName:searchBar.text];
        
        _foundTags = nil;
        [_collectionView reloadData];
        
        searchBar.text = @"";
        [searchBar resignFirstResponder];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if ([_foundTags count]) {
        return CGSizeZero;
    }
    
    return CGSizeMake(self.collectionView.bounds.size.width - 20, 21);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = nil;

    if (kind == UICollectionElementKindSectionHeader) {
        view = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kTagsSectionHeader forIndexPath:indexPath];
        TagsSectionHeadersCollectionReusableView *headerView = (TagsSectionHeadersCollectionReusableView *)view;
        headerView.label.text = [[TagsStore sharedStore] characterForSection:indexPath.section];
    }

    return view;
}

@end