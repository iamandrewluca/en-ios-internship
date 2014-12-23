//
//  NoteImagesCollectionViewController.m
//  ENote
//
//  Created by Andrei Luca on 12/22/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NoteImagesCollectionViewController.h"
#import "NoteImagesCollectionViewCell.h"
#import "AddNoteImageCollectionViewCell.h"
#import "ImagesStore.h"
#import "NotesDetailViewController.h"

@interface NoteImagesCollectionViewController () <NoteImagesCollectionViewCellDelegate>

@end

@implementation NoteImagesCollectionViewController

static NSString * const kAddNoteImageReuseIdentifier = @"AddNoteImageCollectionViewCell";
static NSString * const kNoteImageReuseIdentifier = @"NoteImagesCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:kAddNoteImageReuseIdentifier bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:kAddNoteImageReuseIdentifier];
    
    nib = [UINib nibWithNibName:kNoteImageReuseIdentifier bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:kNoteImageReuseIdentifier];
    
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(willEnterEditMode:)];
    [self.collectionView addGestureRecognizer:longTap];
}

- (void)willEnterEditMode:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (self.isEditing) {
            [self setEditing:NO animated:YES];
        } else {
            [self setEditing:YES animated:YES];
        }
    }
}

- (void)changeButtonsStateTo:(BOOL)hide
{
    for (int i = 0; i < [self.collectionView numberOfItemsInSection:0] - 1; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        NoteImagesCollectionViewCell *cell = (NoteImagesCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        
        NSString *imageID = [_note.imagesIDs objectAtIndex:indexPath.row];
        
        if ([imageID isEqualToString:_note.thumbID]) {
            cell.thumbCheck.hidden = hide;
        }
        
        cell.deleteButton.hidden = hide;
    }
}

- (void)hideButtons:(BOOL)hide animated:(BOOL)animated
{
    NSTimeInterval interval = 0.0f;
    CGFloat alpha = 1.0f;
    
    if (animated) {
        interval = 0.2f;
    }
    
    if (hide) {
        alpha = 0.0f;
    }
    
    if (!hide) {
        [self changeButtonsStateTo:hide];
    }
    
    [UIView animateWithDuration:interval animations:^{
        for (int i = 0; i < [self.collectionView numberOfItemsInSection:0] - 1; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            NoteImagesCollectionViewCell *cell = (NoteImagesCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            
            NSString *imageID = [_note.imagesIDs objectAtIndex:indexPath.row];
            
            if ([imageID isEqualToString:_note.thumbID]) {
                cell.thumbCheck.alpha = alpha;
            }
            
            cell.deleteButton.alpha = alpha;
        }
    } completion:^(BOOL finished) {
        if (hide) {
            [self changeButtonsStateTo:hide];
        }
    }];
}

- (void)showButtons:(BOOL)show animated:(BOOL)animated
{
    [self hideButtons:!show animated:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[_note.imagesIDs count] inSection:0];
    AddNoteImageCollectionViewCell *cell = (AddNoteImageCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    if (editing) {
        cell.label.text = @"done";
        [self showButtons:YES animated:animated];
    } else {
        cell.label.text = @"add";
        [self hideButtons:YES animated:animated];
    }
}

- (void)setEditing:(BOOL)editing
{
    [super setEditing:editing];
    [self setEditing:editing animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <NoteImagesCollectionViewCellDelegate>

- (void)deleteButtonPressedInCell:(NoteImagesCollectionViewCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    cell.deleteButton.hidden = YES;
    cell.thumbCheck.hidden = YES;
    
    NSString *imageID = [_note.imagesIDs objectAtIndex:indexPath.row];
    [[ImagesStore sharedStore] removeImageForNote:_note withImageID:imageID];
    
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    
    if (![_note.imagesIDs count]) {
        [self setEditing:NO];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_note.imagesIDs count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    
    if (indexPath.row == [self.collectionView numberOfItemsInSection:0] - 1) {
        AddNoteImageCollectionViewCell *noteCell = [collectionView dequeueReusableCellWithReuseIdentifier:kAddNoteImageReuseIdentifier forIndexPath:indexPath];
        cell = noteCell;
    } else {
        NoteImagesCollectionViewCell *noteCell = [collectionView dequeueReusableCellWithReuseIdentifier:kNoteImageReuseIdentifier forIndexPath:indexPath];
        noteCell.delegate = self;
        NSString *preview = [_note.imagesIDs objectAtIndex:indexPath.row];
        noteCell.thumbImage.image = [[ImagesStore sharedStore] previewForNote:_note withImageID:preview];
        
        if (self.isEditing) {
            noteCell.deleteButton.hidden = NO;
            noteCell.deleteButton.alpha = 1.0f;
            noteCell.thumbCheck.alpha = 1.0f;
            
            if ([_note.thumbID isEqualToString:[_note.imagesIDs objectAtIndex:indexPath.row]]) {
                            NSLog(@"Asd");
                noteCell.thumbCheck.hidden = YES;
            } else {
                noteCell.thumbCheck.hidden = NO;
            }
        } else {
            noteCell.thumbCheck.hidden = YES;
            noteCell.deleteButton.hidden = YES;
        }
        
        cell = noteCell;
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.collectionView numberOfItemsInSection:0] - 1) {
        if (self.isEditing) {
            [self setEditing:NO animated:YES];
        } else {
            [((NotesDetailViewController *)self.parentViewController) addImage];
        }
    } else {
        if (self.isEditing) {
            NSString *imageID = [_note.imagesIDs objectAtIndex:indexPath.row];
            [[ImagesStore sharedStore] setThumbForNote:_note withImageID:imageID];
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        } else {
            // image popover
        }
    }
}

@end
