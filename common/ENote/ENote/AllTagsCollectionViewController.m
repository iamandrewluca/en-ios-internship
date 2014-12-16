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
    } else {
        tag = [[[TagsStore sharedStore] allTags] objectAtIndex:indexPath.row];
    }
    
    [_foundTags removeObject:tag];
    [[TagsStore sharedStore] removeTag:tag];
    
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_foundTags count] != 0) {
        Tag *tag = [_foundTags objectAtIndex:indexPath.row];
        _sizingCell.label.text = tag.name;
    } else {
        NSArray *tags = [[TagsStore sharedStore] tagsForSection:indexPath.section];
        _sizingCell.label.text = [[tags objectAtIndex:indexPath.row] name];
    }
    
    // return size it will take from default _sizingCell
    return [_sizingCell systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundPattern"]];
    
    UINib *nib = [UINib nibWithNibName:kTagCollectionViewCell bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:kTagCollectionViewCell];
    
    nib = [UINib nibWithNibName:kTagsSectionHeader bundle:nil];
    [self.collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kTagsSectionHeader];
    
    _sizingCell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[TagsStore sharedStore] countAvailableSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([_foundTags count] != 0) {
        return [_foundTags count];
    } else {
        return [[TagsStore sharedStore] countInSection:section];
    }
    
    return 0;
}

//- (NSString *)characterForSection:(NSInteger)section
//{
//    NSString *sectionString = nil;
//    
//    if (section < 26) {
//        sectionString = [NSString stringWithFormat:@"%c", (char)(65 + section)];
//    } else if (section < 36) {
//        sectionString = [NSString stringWithFormat:@"%c", (char)(48 + section)];
//    } else {
//        sectionString = @"#";
//    }
//    
//    return sectionString;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTagCollectionViewCell forIndexPath:indexPath];
    
    if ([_foundTags count] != 0) {
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
        
    } else {
        [[TagsStore sharedStore] createTagWithName:searchBar.text];
        
        if ([_foundTags count]) {
            _foundTags = nil;
            [_collectionView reloadData];
        } else {
            [self.collectionView reloadData];
        }
        searchBar.text = @"";
        [searchBar resignFirstResponder];
    }
}

@end
