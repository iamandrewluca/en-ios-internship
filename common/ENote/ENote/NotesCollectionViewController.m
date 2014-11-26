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

#define selectedTag 100
#define cellSize 99
#define textLabelHeight 20
#define cellAAcitve 1.0
#define cellADeactive 0.3
#define cellAHidden 0.0
#define defaultFontSize 10.0

static NSString * const NoteCellIdentifier = @"NoteCell";

@interface NotesCollectionViewController () {
    UIBarButtonItem *addNote;
}

@property (nonatomic, weak) IBOutlet NotesLayout *notesLayout;
@property (nonatomic) NSMutableArray *selectedItems;
@end

@implementation NotesCollectionViewController {
    UILongPressGestureRecognizer *longPress;
    NSIndexPath *lastAccessed;
}

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.notebook.name;
    self.collectionView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:134.0/255.0 blue:13.0/255.0 alpha:1.0];
    
    // Register cell and title classes with the collection view
    [self.collectionView registerClass:[NoteCell class] forCellWithReuseIdentifier:NoteCellIdentifier];
    [self.collectionView setAllowsMultipleSelection:YES];
    
    // Selection panGesture
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleGesture:)];
    [self.view addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer setMinimumNumberOfTouches:1];
    [gestureRecognizer setMaximumNumberOfTouches:1];
    
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
                                                   [self.notebook.notesStore createNoteWithName:titleFromModal];
                                                   
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
        self.editButtonItem.title = @"Remove";
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
    return [[self.notebook.notesStore allNotes] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NoteCell *noteCell = [collectionView dequeueReusableCellWithReuseIdentifier:NoteCellIdentifier forIndexPath:indexPath];
    noteCell.nameLabel.text = [[[self.notebook.notesStore allNotes] objectAtIndex:indexPath.section] name];
    
    if (![noteCell viewWithTag:selectedTag])
    {
        UILabel *selected = [[UILabel alloc] initWithFrame:CGRectMake(0, cellSize - textLabelHeight, cellSize, textLabelHeight)];
        selected.backgroundColor = [UIColor blackColor];
        selected.textColor = [UIColor whiteColor];
        selected.text = @"PICKED";
        selected.textAlignment = NSTextAlignmentCenter;
        selected.font = [UIFont systemFontOfSize:defaultFontSize];
        selected.tag = selectedTag;
        selected.alpha = cellAHidden;
        
        [noteCell.contentView addSubview:selected];
    }
    
    [[noteCell viewWithTag:selectedTag] setAlpha:cellAHidden];
    noteCell.backgroundView.alpha = cellADeactive;
    
    // highlight the selected cell
    bool cellSelected = [selectedIdx objectForKey:[NSString stringWithFormat:@"%li", indexPath.section]];
    [self setCellSelection:noteCell selected:cellSelected];
    
    return noteCell;
}

- (void)deleteNotes {
    
    for (NSIndexPath *indexPath in self.selectedItems) {
        Note *note = [[self.notebook.notesStore allNotes] objectAtIndex:indexPath.section];
        
        [self.notebook.notesStore removeNote:note];
        
        [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    }
}



#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.editing) {
        
        [self.selectedItems addObject:indexPath];
        
        
        [self setCellSelection:cell selected:YES];
        
        //-------------- Delete Note ---------------//
//        NotesStore *notesStore = self.notebook.notesStore;
//        Note *note = [[notesStore allNotes] objectAtIndex:indexPath.row];
//        [notesStore removeNote:note];
//        
//        [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    }
    else {
        NotesDetailViewController *nvc = [[NotesDetailViewController alloc]init];
        nvc.note = [[self.notebook.notesStore allNotes] objectAtIndex:indexPath.section];
        [[self navigationController] pushViewController:nvc animated:YES];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        
        [self.selectedItems removeObject:indexPath];
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
    cell.backgroundView.alpha = selected ? cellAAcitve : cellADeactive;
    [cell viewWithTag:selectedTag].alpha = selected ? cellAAcitve : cellAHidden;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    float pointerX = [gestureRecognizer locationInView:self.collectionView].x;
    float pointerY = [gestureRecognizer locationInView:self.collectionView].y;
    
    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        float cellSX = cell.frame.origin.x;
        float cellEX = cell.frame.origin.x + cell.frame.size.width;
        float cellSY = cell.frame.origin.y;
        float cellEY = cell.frame.origin.y + cell.frame.size.height;
        
        if (pointerX >= cellSX && pointerX <= cellEX && pointerY >= cellSY && pointerY <= cellEY)
        {
            NSIndexPath *touchOver = [self.collectionView indexPathForCell:cell];
            
            if (lastAccessed != touchOver)
            {
                if (cell.selected)
                    [self deselectCellForCollectionView:self.collectionView atIndexPath:touchOver];
                else
                    [self selectCellForCollectionView:self.collectionView atIndexPath:touchOver];
            }
            
            lastAccessed = touchOver;
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        lastAccessed = nil;
        self.collectionView.scrollEnabled = YES;
    }
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
