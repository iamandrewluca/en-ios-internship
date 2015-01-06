//
//  NoteTagsCollectionViewController.m
//  ENote
//
//  Created by Andrei Luca on 1/6/15.
//  Copyright (c) 2015 Endava. All rights reserved.
//

#import "NoteTagsCollectionViewController.h"
#import "TagCollectionViewCell.h"
#import "AddTagCollectionViewCell.h"
#import "Note.h"
#import "NotesStore.h"
#import "Tag.h"
#import "AddTagsViewController.h"
#import "TagsStore.h"
#import "UIViewController+MJPopupViewController.h"

static NSString *const kAddTagCellIdentifier = @"AddTagCollectionViewCell";
static NSString *const kTagCellIdentifier = @"TagCollectionViewCell";

@interface NoteTagsCollectionViewController () <TagCellDelegate>

@end

@implementation NoteTagsCollectionViewController
{
    TagCollectionViewCell *_sizingCell;
}

#pragma mark <TagCellDelegate>

- (void)buttonPressedInCell:(TagCollectionViewCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    NSString *tagID = [_note.tagsIDs objectAtIndex:indexPath.row - 1];
    [_note removeTagID:tagID];
    [_notesStore saveNote:_note];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

#pragma mark View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Tag registering
    UINib *cellNib = [UINib nibWithNibName:kTagCellIdentifier bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:kTagCellIdentifier];
    
    // get a cell as template for sizing
    _sizingCell = [[cellNib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    
    cellNib = [UINib nibWithNibName:kAddTagCellIdentifier bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:kAddTagCellIdentifier];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_note.tagsIDs count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    
    if (indexPath.row) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTagCellIdentifier forIndexPath:indexPath];
        TagCollectionViewCell *tagCell = (TagCollectionViewCell *)cell;
        NSString *tagID = [[_note tagsIDs] objectAtIndex:indexPath.row - 1];
        Tag *tag = [[TagsStore sharedStore] getTagWithID:tagID];
        tagCell.label.text = tag.name;
        tagCell.delegate = self;
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAddTagCellIdentifier forIndexPath:indexPath];
        AddTagCollectionViewCell *addCell = (AddTagCollectionViewCell *)cell;
        [addCell.addButton addTarget:self action:@selector(addTag:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

// called for each cell to know the size it will take
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row) {
        NSString *tagID = [[_note tagsIDs] objectAtIndex:indexPath.row - 1];
        Tag *tag = [[TagsStore sharedStore] getTagWithID:tagID];
        _sizingCell.label.text = tag.name;
        
        // return size it will take from default _sizingCell
        return [_sizingCell systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
    } else {
        return CGSizeMake(26, 26);
    }
}

#pragma mark - Button actions

- (void)addTag:(id)sender
{
    AddTagsViewController *addTags = [[AddTagsViewController alloc]init];
    addTags.notesStore = _notesStore;
    addTags.note = _note;
    addTags.pctrl = self;
    
    [self presentPopupViewController:addTags animationType:MJPopupViewAnimationFade];
}

@end
