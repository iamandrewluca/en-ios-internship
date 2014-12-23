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

@interface NoteImagesCollectionViewController ()

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    
    if (indexPath.row) {
        NoteImagesCollectionViewCell *noteCell = [collectionView dequeueReusableCellWithReuseIdentifier:kNoteImageReuseIdentifier forIndexPath:indexPath];
        NSString *preview = [_note.imagesIDs objectAtIndex:indexPath.row];
        noteCell.thumbImage.image = [[ImagesStore sharedStore] previewForNote:_note withImageID:preview];
        cell = noteCell;
    } else {
        AddNoteImageCollectionViewCell *noteCell = [collectionView dequeueReusableCellWithReuseIdentifier:kAddNoteImageReuseIdentifier forIndexPath:indexPath];
        cell = noteCell;
    }    
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
