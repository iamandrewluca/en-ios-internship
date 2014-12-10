//
//  NotesDetailViewController.m
//  ENote
//
//  Created by iboicenco on 11/13/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotesDetailViewController.h"
#import "TagCollectionViewCell.h"
#import "Tag.h"
#import "TagsStore.h"
#import "Note.h"

@interface NotesDetailViewController () <TagCellDelegate, UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

@property (nonatomic) BOOL noteWasDeleted;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomSpace;
@property (weak, nonatomic) IBOutlet UITextView *addNotesTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *tagsCollectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic) NSArray *foundTags;

@end

@implementation NotesDetailViewController
{
    TagCollectionViewCell *_sizingCell;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeNoteTextView:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeNoteTextView:) name:UIKeyboardDidHideNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)buttonPressedInCell:(TagCollectionViewCell *)cell
{
    //    NSString *tagID = [_note.tagsIDs objectAtIndex:indexPath.row];
    //    [_note removeTagID:tagID];
    //
    //    [self.tagsCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    
    //    if ([_tagsCollectionView numberOfItemsInSection:0] == 0) {
    //
    //        [UIView animateWithDuration:0.5f animations:^{
    //            _tagsCollectionViewHeight.constant = 0;
    //            _tagsCollectionViewBottomSpace.constant = 0;
    //
    //            [self.view layoutIfNeeded];
    //        }];
    //    }
    if (cell.canBeDeleted) {
        NSIndexPath *indexPath = [_tagsCollectionView indexPathForCell:cell];
        
        NSString *tagID = [_note.tagsIDs objectAtIndex:indexPath.row];
        [_note removeTagID:tagID];
        [_notesStore saveNote:_note];
        [_tagsCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (![searchBar.text isEqualToString:@""]) {
        Tag *tag = [[TagsStore sharedStore] createTagWithName:searchBar.text];
        
        BOOL addedTag = [_note addTagID:tag.ID];
        
        if (addedTag) {
            searchBar.text = @"";
            [_notesStore saveNote:_note];
            [_tagsCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
            [searchBar resignFirstResponder];
            [self.tagsCollectionView reloadData];
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSUInteger foundTagsLastTime = [_foundTags count] != 0;
    
    _foundTags = [[TagsStore sharedStore] tagsWhichContainText:searchText];
    
    if ([_foundTags count] || ([_foundTags count] == 0 && foundTagsLastTime)) {
        [self.tagsCollectionView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = _note.name;
    
    _addNotesTextView.layer.cornerRadius = 5.0f;
    
    if (![_note.name isEqualToString:@""]) {
        self.addNotesTextView.text = _note.text;
    }
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(actioSheetMenu)];
    self.navigationItem.rightBarButtonItem = menuButton;
    
    _addNotesTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    
    // Tag registering
    UINib *cellNib = [UINib nibWithNibName:@"TagCollectionViewCell" bundle:nil];
    [self.tagsCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"TagCell"];
    
    // get a cell as template for sizing
    _sizingCell = [[cellNib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    
    _searchBar.returnKeyType = UIReturnKeyDone;
}

- (void)resizeNoteTextView:(NSNotification *)notification
{
    if (notification.name == UIKeyboardDidShowNotification) {
        NSDictionary *keyboardInfo = [notification userInfo];
        NSValue *keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
        CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
        
        _textViewBottomSpace.constant = 8 + keyboardFrameBeginRect.size.height;
        
    } else if (notification.name == UIKeyboardDidHideNotification) {
        _textViewBottomSpace.constant = 8;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_foundTags count] != 0) {
        return [_foundTags count];
    } else {
        return [_note.tagsIDs count];
    }
}

- (void)_configureCell:(TagCollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    if ([_foundTags count] != 0) {
        Tag *tag = [_foundTags objectAtIndex:indexPath.row];
        cell.label.text = tag.name;
        
        if ([_note hasTagID:tag.ID]) {
            cell.canBeDeleted = YES;
        } else {
            cell.canBeDeleted = NO;
        }
    } else {
        NSString *tagID = [[_note tagsIDs] objectAtIndex:indexPath.row];
        Tag *tag = [[TagsStore sharedStore] getTagWithID:tagID];
        cell.label.text = tag.name;
        cell.canBeDeleted = YES;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    [self _configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

// called for each cell to know the size it will take
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // set cell content
    if ([_foundTags count] != 0) {
        Tag *tag = [_foundTags objectAtIndex:indexPath.row];
        _sizingCell.label.text = tag.name;
    } else {
        NSString *tagID = [[_note tagsIDs] objectAtIndex:indexPath.row];
        Tag *tag = [[TagsStore sharedStore] getTagWithID:tagID];
        _sizingCell.label.text = tag.name;
    }
    
    // return size it will take from default _sizingCell
    return [_sizingCell systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
}

- (void)actioSheetMenu
{
    
    [_addNotesTextView resignFirstResponder];
    [_searchBar resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What do you want to do with the note?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete it"
                                                    otherButtonTitles:@"Rename", @"Move", nil];
    
    [actionSheet showInView:self.view];
    actionSheet.tag = 100;
}

-(void)deleteConfirmation
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Really delete the selected note?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Yes, delete it"
                                                    otherButtonTitles:nil];
    

    [actionSheet showInView:self.view];
    actionSheet.tag = 200;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 100 && buttonIndex == 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Rename note title"
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.returnKeyType = UIReturnKeyDone;
            textField.placeholder = @"Rename title";
        }];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       
                                                       NSString *titleFromModal = [[[alert textFields] firstObject] text];
                                                       if (![titleFromModal isEqualToString:@""]) {
                                                           _note.name = titleFromModal;
                                                           [_notesStore saveNote:_note];
                                                           self.navigationItem.title = _note.name;
                                                       }
                                                   }];
        
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
        
        [alert addAction:cancel];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

 
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100 && buttonIndex == 0) {
        [self deleteConfirmation];
    } else if(actionSheet.tag == 100 && buttonIndex == 1) {
        NSLog(@"Rename");
    } else if(actionSheet.tag == 100 && buttonIndex == 2) {
        NSLog(@"Move");
    }
    if (actionSheet.tag == 200) {
        if(buttonIndex == 0) {
            self.noteWasDeleted = YES;
            [self.navigationController popViewControllerAnimated:TRUE];
            [_notesStore removeNote:self.note];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.noteWasDeleted == NO) {

        self.note.text = self.addNotesTextView.text;
        [_notesStore saveNote:_note];
    }
}

@end
