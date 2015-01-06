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
#import "NoteLargeCell.h"
#import "Note.h"
#import "NotebooksStore.h"
#import "NotesAddCell.h"
#import "ImagesStore.h"

#import "NoteCellGrid.h"
#import "NoteCellLarge.h"

static NSString *const NoteCellIdentifier = @"NoteCell";
static NSString *const AddNoteCellIdentifier = @"NotesAddCell";
static NSString *const NoteLargeCellIdentifier = @"NoteLargeCell";

@interface NotesCollectionViewController () {
    NSIndexPath *selectedNoteIndexPath;
    UILongPressGestureRecognizer *longPress;
    UIBarButtonItem *addNote;
    UIBarButtonItem *gridViewButton;
    UIBarButtonItem *tableViewButton;
}

@property (nonatomic, copy)   NSArray *buttons;
@property (nonatomic, strong) NoteCellLarge *largeLayout;
@property (nonatomic, strong) NoteCellGrid *gridLayout;

@end

@implementation NotesCollectionViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.backgroundView = [[UIView alloc] initWithFrame:self.collectionView.frame];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundPattern"]];
    self.navigationItem.title = _notesStore.notebook.name;

    // Register cells for collection view
    UINib *nib = [UINib nibWithNibName:NoteCellIdentifier bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NoteCellIdentifier];
    
    nib = [UINib nibWithNibName:NoteLargeCellIdentifier bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NoteLargeCellIdentifier];
    
    // Regsiter notes add cell for collection viewce
    nib = [UINib nibWithNibName:AddNoteCellIdentifier bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:AddNoteCellIdentifier];
    
    // Long press for entering editing mode
    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(enterEditMode:)];
    [self.collectionView addGestureRecognizer:longPress];
    
    // Add new note
    addNote = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                     target:self
                                                                     action:@selector(addNewNote)];
    
    self.navigationItem.rightBarButtonItem = addNote;
    
    self.largeLayout = [NoteCellLarge new];
    self.largeLayout.itemSize = CGSizeMake(self.collectionView.bounds.size.width - self.largeLayout.sectionInset.left - self.largeLayout.sectionInset.right - 1, 100);
    
    self.gridLayout = [NoteCellGrid new];
    
    [self.collectionView setCollectionViewLayout:self.gridLayout];
    
    // grid layout button
    gridViewButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"gridView"]
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(buttonLayoutControlValueDidChange:)];
    // table layout button
    tableViewButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tableView"]
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(buttonLayoutControlValueDidChange:)];
    
    self.buttons = @[addNote, tableViewButton];
    self.navigationItem.rightBarButtonItems = self.buttons;
    
    [self.collectionView setAllowsMultipleSelection:YES];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (self.collectionView.collectionViewLayout == self.largeLayout) {
        self.largeLayout.itemSize = CGSizeMake(self.collectionView.bounds.size.width - self.largeLayout.sectionInset.left - self.largeLayout.sectionInset.right - 1, 100);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (selectedNoteIndexPath) {
        if (_noteWasDeleted) {
            [self.collectionView deleteItemsAtIndexPaths:@[selectedNoteIndexPath]];
        } else {
            [self.collectionView reloadItemsAtIndexPaths:@[selectedNoteIndexPath]];
        }
        selectedNoteIndexPath = nil;
    }
}

#pragma mark - Button actions
-(void)buttonLayoutControlValueDidChange:(id)sender
{
    __weak NotesCollectionViewController *selfWeak = self;
    
    if (self.collectionView.collectionViewLayout == self.gridLayout) {
        gridViewButton.image = [UIImage imageNamed:@"gridView"];
        self.buttons = @[addNote, gridViewButton];
        self.navigationItem.rightBarButtonItems = self.buttons;
        
        [self.largeLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:self.largeLayout animated:NO completion:^(BOOL finished) {
            if (finished) {
                [selfWeak.collectionView performBatchUpdates:^{
                    [selfWeak.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                } completion:nil];
            }
        }];
    } else {
        tableViewButton.image = [UIImage imageNamed:@"tableView"];
        self.buttons = @[addNote, tableViewButton];
        self.navigationItem.rightBarButtonItems = self.buttons;
        
        [self.gridLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:self.gridLayout animated:NO completion:^(BOOL finished) {
            if (finished) {
                [selfWeak.collectionView performBatchUpdates:^{
                    [selfWeak.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                } completion:nil];
            }
        }];
    }
}

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
                                                   NSUInteger index = [self.collectionView numberOfItemsInSection:0] - 1;
                                                   NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
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
        ((NoteCell *)noteCell).checked.image = [UIImage imageNamed:@"unchecked"];
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
        if (self.isEditing) {
            [self setEditing:NO animated:YES];
        } else {
            [self setEditing:YES animated:YES];
        }
        
        CGPoint point = [gestureRecognizer locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[_notesStore allNotes] count] + 1; // plus one for add note cell
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    
    if ([self isLastIndexPath:indexPath]) {
        // if is last cell
        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:AddNoteCellIdentifier forIndexPath:indexPath];
        [((NotesAddCell *)cell).addNote addTarget:self action:@selector(addNewNote) forControlEvents:UIControlEventTouchUpInside];
    } else {
        // if is not last cell
        
        Note *note = [[_notesStore allNotes] objectAtIndex:indexPath.row];
        
        if (collectionView.collectionViewLayout == self.largeLayout) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NoteLargeCellIdentifier forIndexPath:indexPath];
            ((NoteLargeCell *)cell).noteDescription.text = note.text;
            
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            dateFormatter.dateStyle = NSDateFormatterMediumStyle;
            dateFormatter.timeStyle = NSDateFormatterNoStyle;
            
            ((NoteLargeCell *)cell).date.text = [dateFormatter stringFromDate:note.dateCreated];
        } else {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NoteCellIdentifier forIndexPath:indexPath];
            NoteCell *noteCell = (NoteCell *)cell;
            
            UIImage *thumbImage = [[ImagesStore sharedStore] thumbForNote:note];
            
            if (thumbImage) {
                noteCell.thumbnailImage.image = thumbImage;
            } else {
                noteCell.thumbnailImage.image = [UIImage imageNamed:@"racoon-orange"];
            }
        }
        
        ((NoteCell *)cell).nameLabel.text = note.name;
    }
    
    return cell;
}

- (void)deleteNotes
{
    NSMutableArray *notes = [NSMutableArray new];
    
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
        Note *note = [[_notesStore allNotes] objectAtIndex:indexPath.row];
        [notes addObject:note];
    }
    
    for (Note *note in notes) {
        [_notesStore removeNote:note];
    }
    
    [self.collectionView deleteItemsAtIndexPaths:self.collectionView.indexPathsForSelectedItems];
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
            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
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
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
            ((NoteCell *)cell).checked.image = [UIImage imageNamed:@"unchecked"];
        }
    }
}

@end
