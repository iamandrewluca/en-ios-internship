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
#import "Notebook.h"
#import "NoteCell.h"
#import "Note.h"
#import "NotebooksStore.h"
#import "NotesAddCell.h"

static NSString *const NoteCellIdentifier = @"NoteCell";
static NSString *const AddNoteCellIdentifier = @"NotesAddCell";

@interface NotesCollectionViewController () {
    NSIndexPath *selectedNoteIndexPath;
    UILongPressGestureRecognizer *longPress;
    UIBarButtonItem *addNote;
    UIImageView *noNotesBack;
}

@property (nonatomic) NSMutableArray *selectedItems;

@end

@implementation NotesCollectionViewController

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = _notesStore.notebook.name;
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundPattern"]];

    // Register cells for collection view
    UINib *nib = [UINib nibWithNibName:NoteCellIdentifier bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NoteCellIdentifier];
    
    // Regsiter notes add cell for collection viewce
    nib = [UINib nibWithNibName:AddNoteCellIdentifier bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:AddNoteCellIdentifier];
    
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
    
    // Prepare collectionView empty background
    UIImage *image = [UIImage imageNamed:@"addSomeNotebooks"];
    noNotesBack = [[UIImageView alloc] initWithImage:image];
    
    self.collectionView.backgroundView = [[UIView alloc] initWithFrame:self.collectionView.frame];
    
    [self.collectionView.backgroundView addSubview:noNotesBack];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Center emptyTableViewBackground every time layout will change
    [noNotesBack setCenter:CGPointMake(self.collectionView.center.x, self.collectionView.center.y - noNotesBack.image.size.height / 2)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (selectedNoteIndexPath) {
        [self.collectionView reloadItemsAtIndexPaths:@[selectedNoteIndexPath]];
    }
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
                                                   
                                                   NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                                                   [self.collectionView insertItemsAtIndexPaths:@[indexPath]];

                                               }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)hideCheckBoxes:(BOOL)hide
{
    for (int i = 0; i < [self.collectionView numberOfItemsInSection:0] - 1; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewCell *noteCell = [self.collectionView cellForItemAtIndexPath:indexPath];
        ((NoteCell *)noteCell).checked.hidden = hide;
    }
}

- (void)showCheckBoxes:(BOOL)show
{
    [self hideCheckBoxes:!show];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (!editing) {
        self.navigationItem.rightBarButtonItem = addNote;
        [self hideCheckBoxes:YES];
        [self deleteNotes];
    } else {
        self.editButtonItem.image = [UIImage imageNamed:@"trash"];
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        [self showCheckBoxes:YES];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSUInteger count = [[_notesStore allNotes] count];
    
    if (count == 0) {
        if ([[[collectionView.backgroundView subviews] firstObject] isHidden]) {
            [[[collectionView.backgroundView subviews] firstObject] setHidden:NO];
        }
    }
    
    return count + 1; // plus one for add note cell
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView numberOfItemsInSection:0] > 1) {
        if (![[[collectionView.backgroundView subviews] firstObject] isHidden]) {
            [[[collectionView.backgroundView subviews] firstObject] setHidden:YES];
        }
    }
    
    UICollectionViewCell *cell = nil;
    
    if ([self isLastIndexPath:indexPath]) {
        // if is last cell
        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:AddNoteCellIdentifier forIndexPath:indexPath];
        [((NotesAddCell *)cell).addNote addTarget:self action:@selector(addNewNote) forControlEvents:UIControlEventTouchUpInside];
    } else {
        // if is not last cell
        
        Note *note = [[_notesStore allNotes] objectAtIndex:indexPath.row];
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NoteCellIdentifier forIndexPath:indexPath];
        NoteCell *noteCell = (NoteCell *)cell;
        noteCell.nameLabel.text = note.name;
        
        UIImage *thumbImage = [_notesStore imageForNote:note];
        
        if (thumbImage) {
            noteCell.thumbnailImage.image = thumbImage;
        } else {
            noteCell.thumbnailImage.image = [UIImage imageNamed:@"racoon-orange"];
        }
    }
    
    return cell;
}

- (void)deleteNotes {

    for (NSIndexPath *indexPath in _selectedItems) {
        Note *note = [[_notesStore allNotes] objectAtIndex:indexPath.row];
        [_notesStore removeNote:note];
    }
    
    [self.collectionView deleteItemsAtIndexPaths:_selectedItems];
    
    [_selectedItems removeAllObjects];
}

- (BOOL)isLastIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == ([self.collectionView numberOfItemsInSection:0] - 1);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self isLastIndexPath:indexPath]) {
        if (self.editing) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            [self.selectedItems addObject:indexPath];
            ((NoteCell *)cell).checked.image = [UIImage imageNamed:@"checked"];
        } else {
            
            NotesDetailViewController *nvc = [[NotesDetailViewController alloc]init];
            Note *note = [[_notesStore allNotes] objectAtIndex:indexPath.row];
            nvc.note = note;
            nvc.notesStore = _notesStore;
            selectedNoteIndexPath = indexPath;
            [[self navigationController] pushViewController:nvc animated:YES];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self isLastIndexPath:indexPath]) {
        if (self.editing) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            [self.selectedItems removeObject:indexPath];
            ((NoteCell *)cell).checked.image = [UIImage imageNamed:@"unchecked"];
        }
    }
}

@end
