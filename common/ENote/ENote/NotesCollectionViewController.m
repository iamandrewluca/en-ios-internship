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

static int const kSelectedTag = 100;
static int const kCellSize = 99;
static int const kTextLabelHeight = 20;
static double const kCellaActive = 1.0;
static double const kCellaDeactive = 0.3;
static double const kCellaHidden = 0.0;
static double const kDefaultFontSize = 10.0;

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
    [self.collectionView registerClass:[NoteCell class] forCellWithReuseIdentifier:NoteCellIdentifier];
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
                                                   
                                                   [self.collectionView reloadData];
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
        [self deleteNotes];
    } else {
        self.editButtonItem.image = [UIImage imageNamed:@"trash"];
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    if (![noteCell viewWithTag:kSelectedTag])
    {
        UILabel *selected = [[UILabel alloc] initWithFrame:CGRectMake(0, kCellSize - kTextLabelHeight, kCellSize, kTextLabelHeight)];
        selected.backgroundColor = [UIColor lightGrayColor];
        selected.textColor = [UIColor blackColor];
        selected.text = @"SELECTED";
        selected.textAlignment = NSTextAlignmentCenter;
        selected.font = [UIFont systemFontOfSize:kDefaultFontSize];
        selected.tag = kSelectedTag;
        selected.alpha = kCellaHidden;
        
        [noteCell.contentView addSubview:selected];
    }
    
    [[noteCell viewWithTag:kSelectedTag] setAlpha:kCellaHidden];
    noteCell.backgroundView.alpha = kCellaDeactive;
    
    // highlight the selected cell
    bool cellSelected = [selectedIdx objectForKey:[NSString stringWithFormat:@"%li", indexPath.section]];
    [self setCellSelection:noteCell selected:cellSelected];
    return noteCell;
}

- (void)deleteNotes {
    
    for (int i = 0; i < self.selectedItems.count; i++) {
        [_notesStore removeNote:self.selectedItems[i]];
    }
    
    [self.selectedItems removeAllObjects];
    [self.collectionView reloadData];
}



#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.editing) {
        
        [self.selectedItems addObject:[[_notesStore allNotes] objectAtIndex:indexPath.section]];
        
        
        [self setCellSelection:cell selected:YES];
    }
    else {
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
        
        [self.selectedItems removeObject:[[_notesStore allNotes] objectAtIndex:indexPath.section]];
        [self setCellSelection:cell selected:NO];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Cell selection module
- (void)setCellSelection:(UICollectionViewCell *)cell selected:(bool)selected
{
    cell.backgroundView.alpha = selected ? kCellaActive : kCellaDeactive;
    [cell viewWithTag:kSelectedTag].alpha = selected ? kCellaActive : kCellaHidden;
}

- (void)selectCellForCollectionView:(UICollectionView *)collection atIndexPath:(NSIndexPath *)indexPath
{
    [collection selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:collection didSelectItemAtIndexPath:indexPath];
}

- (void)deselectCellForCollectionView:(UICollectionView *)collection atIndexPath:(NSIndexPath *)indexPath
{
    [collection deselectItemAtIndexPath:indexPath animated:YES];
    [self collectionView:collection didDeselectItemAtIndexPath:indexPath];
}



#pragma mark - View Rotation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.notesLayout.numberOfColumns = 3;
        
        // handle insets for iPhone 4 or 5
        CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ? 45.0f : 25.0f;
        
        self.notesLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
        
    } else {
        self.notesLayout.numberOfColumns = 2;
        self.notesLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    }
}

@end
