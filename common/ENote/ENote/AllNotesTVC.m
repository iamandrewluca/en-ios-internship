//
//  AllNotesTVC.m
//  ENote
//
//  Created by Andrei Luca on 12/19/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "AllNotesTVC.h"
#import "NotebooksStore.h"
#import "AllNotesTVCell.h"
#import "Notebook.h"
#import "NoteCell.h"
#import "NotesStore.h"
#import "Note.h"
#import "NotesDetailViewController.h"

static NSString *const kAllNotesCellIdentifier = @"AllNotesTVCell";

@interface AllNotesTVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation AllNotesTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:kAllNotesCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:kAllNotesCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[NotebooksStore sharedStore] allNotebooks] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllNotesTVCell *cell = (AllNotesTVCell *)[tableView dequeueReusableCellWithIdentifier:kAllNotesCellIdentifier forIndexPath:indexPath];
    
    Notebook *notebook = [[[NotebooksStore sharedStore] allNotebooks] objectAtIndex:indexPath.row];
    cell.notebookLabel.text = notebook.name;
    cell.notesCollectionView.delegate = self;
    cell.notesCollectionView.dataSource = self;
    [cell.notesCollectionView reloadData];
    cell.notesCollectionView.tag = indexPath.row;
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    Notebook *notebook = [[[NotebooksStore sharedStore] allNotebooks] objectAtIndex:collectionView.tag];
    return [notebook.notesIDs count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NoteCell *cell = (NoteCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"NoteCell" forIndexPath:indexPath];
    
    Notebook *notebook = [[[NotebooksStore sharedStore] allNotebooks] objectAtIndex:collectionView.tag];
    NotesStore *store = [[NotebooksStore sharedStore] notesStoreForNotebook:notebook];
    Note *note = [[store allNotes] objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = note.name;
    
    UIImage *thumbImage = [store imageForNote:note];
    
    if (thumbImage) {
        cell.thumbnailImage.image = thumbImage;
    } else {
        cell.thumbnailImage.image = [UIImage imageNamed:@"racoon-orange"];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Notebook *notebook = [[[NotebooksStore sharedStore] allNotebooks] objectAtIndex:collectionView.tag];
    NotesStore *store = [[NotebooksStore sharedStore] notesStoreForNotebook:notebook];
    Note *note = [[store allNotes] objectAtIndex:indexPath.row];
    
    NotesDetailViewController *detailCtrl = [NotesDetailViewController new];
    detailCtrl.notesStore = store;
    detailCtrl.note = note;
    
    [self.navigationController pushViewController:detailCtrl animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 146.0f;
}

@end
