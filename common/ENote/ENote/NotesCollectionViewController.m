//
//  NotesCollectionViewController.m
//  ENote
//
//  Created by iboicenco on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotesCollectionViewController.h"
#import "NotesLayout.h"
#import "NoteCell.h"
#import "NotesDetailViewController.h"
#import "NoteTitleReusableView.h"
#import "Notebook.h"

static NSString * const NoteCellIdentifier = @"NoteCell";
static NSString * const NoteTitleIdentifier = @"Notetitle";

@interface NotesCollectionViewController ()
@property (nonatomic, weak) IBOutlet NotesLayout *notesLayout;
@property (nonatomic, strong) NSMutableArray *notes;

@end

@implementation NotesCollectionViewController
#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    //    UIImage *patternImage = [UIImage imageNamed:@"concrete_wall"];
    self.navigationItem.title = self.notebook.name;
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:134.0/255.0 blue:13.0/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Register cell and title classes with the collection view
    [self.collectionView registerClass:[NoteCell class] forCellWithReuseIdentifier:NoteCellIdentifier];
    [self.collectionView registerClass:[NoteTitleReusableView class] forSupplementaryViewOfKind:NoteLayoutTitleKind
                   withReuseIdentifier:NoteTitleIdentifier];
/*
     //    NSInteger photoIndex = 0;
     //
     //    for (NSInteger n = 0; n < 8; n++) {
     //        NotesStorage *note = [[NotesStorage alloc] init];
     //        note.name = [NSString stringWithFormat:@"Note Folder: %ld",n + 1];
     //
     //        [self.notes addObject:note];
     //
     //    }
     //    photoIndex ++;
     */
    
/*
     //    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
     //                                                                      style:UIBarButtonItemStylePlain
     //                                                                     target:self
     //                                                                     action:@selector(refreshPropertyList:)];
     */
    
}

/*
//-(void)refreshPropertyList:(id)sender
//{
//    UIAlertView *edit = [[UIAlertView alloc]initWithTitle:@"EditNote"
//                                                  message:@""
//                                                 delegate:self
//                                        cancelButtonTitle:@"cancel"
//                                        otherButtonTitles:nil];
//    [edit show];
//}
//
*/

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 8;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *noteCell = [collectionView dequeueReusableCellWithReuseIdentifier:NoteCellIdentifier forIndexPath:indexPath];
    
    return noteCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NotesDetailViewController *nvc = [[NotesDetailViewController alloc]init];
    [[self navigationController] pushViewController:nvc animated:YES];
    
}

/*
 //- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
 //           viewForSupplementaryElementOfKind:(NSString *)kind
 //                                 atIndexPath:(NSIndexPath *)indexPath;
 //{
 //    NoteTitleReusableView *titleView =
 //    [collectionView dequeueReusableSupplementaryViewOfKind:kind
 //                                       withReuseIdentifier:NoteTitleIdentifier
 //                                              forIndexPath:indexPath];
 //
 //    NotesStorage *note = self.notes[indexPath.section];
 //
 //    titleView.titleLabel.text = note.name;
 //
 //    return titleView;
 //}
*/

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

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

//Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}



// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
