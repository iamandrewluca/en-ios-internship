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
#import "ImagesStore.h"

static NSString *const kAllNotesCellIdentifier = @"AllNotesTVCell";

@interface AllNotesTVC () <UICollectionViewDataSource, UICollectionViewDelegate>
@end

@implementation AllNotesTVC
{
    UIImageView *emptyTableViewBackground;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:kAllNotesCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:kAllNotesCellIdentifier];
    
    // Prepare tableView empty background
    UIImage *image = [UIImage imageNamed:@"Empty"];
    emptyTableViewBackground = [[UIImageView alloc] initWithImage:image];
    self.tableView.backgroundView = [[UIView alloc] initWithFrame:self.tableView.frame];
    [self.tableView.backgroundView addSubview:emptyTableViewBackground];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ((UIImageView *)[self.tableView.backgroundView.subviews firstObject]).center = CGPointMake((int)self.tableView.center.x, (int)self.tableView.center.y - 100);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    
    for (Notebook *notebook in [[NotebooksStore sharedStore] allNotebooks]) {
        if ([notebook.notesIDs count]) count++;
    }

    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView numberOfRowsInSection:0] > 0) {
        if (![[[tableView.backgroundView subviews] firstObject] isHidden]) {
            [[[tableView.backgroundView subviews] firstObject] setHidden:YES];
        }
    }
    
    AllNotesTVCell *cell = (AllNotesTVCell *)[tableView dequeueReusableCellWithIdentifier:kAllNotesCellIdentifier forIndexPath:indexPath];
    
    Notebook *notebook = [self notebookAtIndexPath:indexPath];
    cell.notebookLabel.text = notebook.name;
    cell.notesCollectionView.delegate = self;
    cell.notesCollectionView.dataSource = self;
    [cell.notesCollectionView reloadData];
    cell.notesCollectionView.tag = indexPath.row;
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    Notebook *notebook = [self notebookAtIndexPath:[NSIndexPath indexPathForItem:collectionView.tag inSection:0]];
    return [notebook.notesIDs count];
}

- (Notebook *)notebookAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger iterator = 0;
    
    for (Notebook *notebook in [[NotebooksStore sharedStore] allNotebooks]) {
        if ([notebook.notesIDs count]) {
            if (iterator == indexPath.row) {
                return notebook;
            } else {
                iterator++;
            }
        }
    }
    
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NoteCell *cell = (NoteCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"NoteCell" forIndexPath:indexPath];
    
    Notebook *notebook = [self notebookAtIndexPath:[NSIndexPath indexPathForItem:collectionView.tag inSection:0]];
    NotesStore *store = [[NotebooksStore sharedStore] notesStoreForNotebook:notebook];
    Note *note = [[store allNotes] objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = note.name;
    
    UIImage *thumbImage = [[ImagesStore sharedStore] thumbForNote:note];
    
    if (thumbImage) {
        cell.thumbnailImage.image = thumbImage;
    } else {
        cell.thumbnailImage.image = [UIImage imageNamed:@"racoon-orange"];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Notebook *notebook = [self notebookAtIndexPath:[NSIndexPath indexPathForItem:collectionView.tag inSection:0]];
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
