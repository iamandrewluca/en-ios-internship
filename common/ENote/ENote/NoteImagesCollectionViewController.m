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
#import "NoteImagePreviewController.h"

@interface NoteImagesCollectionViewController () <NoteImagesCollectionViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@end

@implementation NoteImagesCollectionViewController

static NSString * const kAddNoteImageReuseIdentifier = @"AddNoteImageCollectionViewCell";
static NSString * const kNoteImageReuseIdentifier = @"NoteImagesCollectionViewCell";

- (void)viewDidLoad
{
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

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        
        if (i == [self.collectionView numberOfItemsInSection:0] - 1) {
            [((AddNoteImageCollectionViewCell *)cell) setEditing:editing animated:animated];
        } else {
            [((NoteImagesCollectionViewCell *)cell) setEditing:editing animated:animated];
        }
    }
}

- (void)setEditing:(BOOL)editing
{
    [super setEditing:editing];
    [self setEditing:editing animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <NoteImagesCollectionViewCellDelegate>

- (void)deleteButtonPressedInCell:(NoteImagesCollectionViewCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    NSString *imageID = [_note.imagesIDs objectAtIndex:indexPath.row];
    [[ImagesStore sharedStore] removeImageForNote:_note withImageID:imageID];
    
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    
    if (![_note.imagesIDs count]) {
        [self setEditing:NO animated:YES];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_note.imagesIDs count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != [self.collectionView numberOfItemsInSection:0] - 1) {
        NoteImagesCollectionViewCell *noteCell = [collectionView dequeueReusableCellWithReuseIdentifier:kNoteImageReuseIdentifier forIndexPath:indexPath];
        noteCell.delegate = self;
        NSString *preview = [_note.imagesIDs objectAtIndex:indexPath.row];
        noteCell.thumbImage.image = [[ImagesStore sharedStore] previewForNote:_note withImageID:preview];
        
        if ([[_note.imagesIDs objectAtIndex:indexPath.row] isEqualToString:_note.thumbID]) {
            noteCell.thumbCheck.image = [UIImage imageNamed:@"checked"];
        }
        
        if (self.isEditing) {
            [noteCell setEditing:YES animated:YES];
        }
        
        return noteCell;
    } else {
        return [collectionView dequeueReusableCellWithReuseIdentifier:kAddNoteImageReuseIdentifier forIndexPath:indexPath];
    }
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != [self.collectionView numberOfItemsInSection:0] - 1) {
        if (self.isEditing) {
            [self changeThumbToIndexPath:indexPath];
        } else {
            // show image picker
            NoteImagePreviewController *preview = [NoteImagePreviewController new];
            preview.note = _note;
            preview.imageID = [_note.imagesIDs objectAtIndex:indexPath.row];
            preview.modalPresentationStyle = UIModalPresentationFullScreen;
            preview.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:preview animated:YES completion:nil];
        }
    } else {
        if (self.isEditing) {
            [self setEditing:NO animated:YES];
        } else {
            [((NotesDetailViewController *)self.parentViewController) addImage];
        }
    }
}

- (void)changeThumbToIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger oldPosition = [_note.imagesIDs indexOfObject:_note.thumbID];
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForItem:oldPosition inSection:0];
    
    if (![oldIndexPath isEqual:indexPath]) {
        NoteImagesCollectionViewCell *oldCell = (NoteImagesCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:oldIndexPath];
        NoteImagesCollectionViewCell *newCell = (NoteImagesCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        
        NSString *imageID = [_note.imagesIDs objectAtIndex:indexPath.row];
        [[ImagesStore sharedStore] setThumbForNote:_note withImageID:imageID];
        
        [oldCell uncheckCell];
        [newCell checkCell];
    }
}

- (void)showImagePickerType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *ipc = [UIImagePickerController new];
    ipc.sourceType = sourceType;
    ipc.delegate = self;
    
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[ImagesStore sharedStore] addImage:info[UIImagePickerControllerOriginalImage] forNote:_note];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if ([_note.imagesIDs count] != 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[_note.imagesIDs count] - 1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
        indexPath = [NSIndexPath indexPathForItem:[_note.imagesIDs count] inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    } else {
        ((NotesDetailViewController *)self.parentViewController).noteImagesTopConstraint.constant = 8;
        
        [UIView animateWithDuration:0.2 animations:^{
            ((NotesDetailViewController *)self.parentViewController).noteImagesHeightConstraint.constant = 64;
            [self.parentViewController.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.collectionView reloadData];
        }];
    }
}

@end
