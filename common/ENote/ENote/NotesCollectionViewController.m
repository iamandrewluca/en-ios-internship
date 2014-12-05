//
//  NotesCollectionViewController.m
//  ENote
//
//  Created by iboicenco on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotesCollectionViewController.h"
#import "NotesDetailViewController.h"
#import "NotesStore.h"
#import "NotesLayout.h"
#import "Notebook.h"
#import "NoteCell.h"
#import "Note.h"
#import "NotebooksStore.h"

static NSString * const NoteCellIdentifier = @"NoteCell";

@interface NotesCollectionViewController () {
    UILongPressGestureRecognizer *longPress;
    NSIndexPath *lastAccessed;
    UIBarButtonItem *addNote;
}

@property (nonatomic, weak) IBOutlet NotesLayout *notesLayout;
@property (nonatomic) NSMutableArray *selectedItems;

@end

@implementation NotesCollectionViewController

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = _notesStore.notebook.name;
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];

    // Register cell and title classes with the collection view
    UINib *nib = [UINib nibWithNibName:@"NoteCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NoteCellIdentifier];
    [self.collectionView setAllowsMultipleSelection:YES];
    
    // Long press for entering editing mode
    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(enterEditMode:)];
    [self.collectionView addGestureRecognizer:longPress];
    
    // Add new note
    addNote = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                     target:self
                                                                     action:@selector(addNewNote)];
    
    self.navigationItem.rightBarButtonItem = addNote;
    self.selectedItems = [[NSMutableArray alloc] init];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}


#pragma mark - Button actions
-(void)addNewNote
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter note title"
                                                     message:@""
                                              preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.returnKeyType = UIReturnKeyDone;
        textField.placeholder = @"Note title";
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   
                                                   NSString *titleFromModal = [[[alert textFields] firstObject] text];
                                                   
                                                   [_notesStore createNoteWithName:titleFromModal];
                                                   
                                                   NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
                                                   
                                                   [self.collectionView insertSections:indexSet];

                                               }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (!editing) {
        self.navigationItem.rightBarButtonItem = addNote;
        
        for (int i = 0; i < [self.collectionView numberOfSections]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
            UICollectionViewCell *noteCell = [self.collectionView cellForItemAtIndexPath:indexPath];
            ((NoteCell *)noteCell).checked.hidden = YES;
        }
        
        [self deleteNotes];
    }
    else
    {
        self.editButtonItem.image = [UIImage imageNamed:@"trash"];
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
        for (int i = 0; i < [self.collectionView numberOfSections]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
            UICollectionViewCell *noteCell = [self.collectionView cellForItemAtIndexPath:indexPath];
            ((NoteCell *)noteCell).checked.hidden = NO;
        }
    }
}


#pragma mark - LongPressGesturEeditingMode
- (void)enterEditMode:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.editing = YES;
    }
}



#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[_notesStore allNotes] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NoteCell *noteCell = [collectionView dequeueReusableCellWithReuseIdentifier:NoteCellIdentifier forIndexPath:indexPath];
    noteCell.nameLabel.text = [[[_notesStore allNotes] objectAtIndex:indexPath.section] name];
    
    //noteCell.layer.borderWidth = 1.5f;
    //noteCell.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    noteCell.layer.shadowColor = [UIColor blackColor].CGColor;
    noteCell.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    noteCell.layer.shadowRadius = 4.0f;
    noteCell.layer.shadowOpacity = 0.5f;
    
    return noteCell;
}

- (void)deleteNotes {
    
    for (int i = 0; i < self.selectedItems.count; i++) {
        
        Note *note = [[_notesStore allNotes] objectAtIndex:[_selectedItems[i] section]];
        [_notesStore removeNote:note];

    }

    [self.selectedItems removeAllObjects];
    [self.collectionView reloadData];
}



#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.editing) {
        [self.selectedItems addObject:indexPath];
         ((NoteCell *)cell).checked.image = [UIImage imageNamed:@"checked"];
    } else {
        NotesDetailViewController *nvc = [[NotesDetailViewController alloc]init];
        Note *note = [[_notesStore allNotes] objectAtIndex:indexPath.section];
        nvc.note = note;
        nvc.notesStore = _notesStore;
        [[self navigationController] pushViewController:nvc animated:YES];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        
        [self.selectedItems removeObject:indexPath];
        ((NoteCell *)cell).checked.image = [UIImage imageNamed:@"unchecked"];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - View Rotation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.notesLayout.numberOfColumns = 3;
    } else {
        self.notesLayout.numberOfColumns = 2;
    }
}

@end
