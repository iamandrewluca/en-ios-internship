//
//  NotesDetailViewController.m
//  ENote
//
//  Created by iboicenco on 11/13/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotesDetailViewController.h"
#import "AllTagsCollectionViewController.h"
#import "TagCollectionViewCell.h"
#import "Tag.h"
#import "TagsStore.h"
#import "Note.h"
#import "AddTagCollectionViewCell.h"

static NSString *const kAddTagCellIdentifier = @"AddTagCollectionViewCell";
static NSString *const kTagCellIdentifier = @"TagCollectionViewCell";

@interface NotesDetailViewController () <TagCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic) BOOL noteWasDeleted;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomSpace;

@property (weak, nonatomic) IBOutlet UITextView *addNotesTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *tagsCollectionView;

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
    NSIndexPath *indexPath = [_tagsCollectionView indexPathForCell:cell];
    
    NSString *tagID = [_note.tagsIDs objectAtIndex:indexPath.row];
    [_note removeTagID:tagID];
    [_notesStore saveNote:_note];
    [_tagsCollectionView deleteItemsAtIndexPaths:@[indexPath]];
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
    
    // tag button
    UIBarButtonItem *tags = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tags"]
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(tagMenu)];
    
    NSArray *buttons = @[menuButton, tags];
    
    self.navigationItem.rightBarButtonItems = buttons;
    
    _addNotesTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    
    // Tag registering
    UINib *cellNib = [UINib nibWithNibName:kTagCellIdentifier bundle:nil];
    [self.tagsCollectionView registerNib:cellNib forCellWithReuseIdentifier:kTagCellIdentifier];
    
    // get a cell as template for sizing
    _sizingCell = [[cellNib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    
    cellNib = [UINib nibWithNibName:kAddTagCellIdentifier bundle:nil];
    [self.tagsCollectionView registerNib:cellNib forCellWithReuseIdentifier:kAddTagCellIdentifier];
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

-(void)tagMenu
{
    AllTagsCollectionViewController *tagsVC = [[AllTagsCollectionViewController alloc]init];
    [self.navigationController pushViewController:tagsVC animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_note.tagsIDs count] + 1;
}

- (BOOL)isLastIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == ([self.tagsCollectionView numberOfItemsInSection:0] - 1);
}

- (void)_configureCell:(TagCollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    NSString *tagID = [[_note tagsIDs] objectAtIndex:indexPath.row];
    Tag *tag = [[TagsStore sharedStore] getTagWithID:tagID];
    cell.label.text = tag.name;
    cell.delegate = self;
}

- (void)addTag:(id)sender
{
    NSLog(@"add tag modal");
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    
    if ([self isLastIndexPath:indexPath]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAddTagCellIdentifier forIndexPath:indexPath];
        AddTagCollectionViewCell *addCell = (AddTagCollectionViewCell *)cell;
        [addCell.addButton addTarget:self action:@selector(addTag:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTagCellIdentifier forIndexPath:indexPath];
        TagCollectionViewCell *tagCell = (TagCollectionViewCell *)cell;        
        [self _configureCell:tagCell forIndexPath:indexPath];
    }
    
    return cell;
}

// called for each cell to know the size it will take
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isLastIndexPath:indexPath]) {
        return CGSizeMake(34, 26);
    } else {
        NSString *tagID = [[_note tagsIDs] objectAtIndex:indexPath.row];
        Tag *tag = [[TagsStore sharedStore] getTagWithID:tagID];
        _sizingCell.label.text = tag.name;
        
        // return size it will take from default _sizingCell
        return [_sizingCell systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
    }
}

- (void)actioSheetMenu
{
    
    [_addNotesTextView resignFirstResponder];
    
    NSString *hasImageText = nil;
    
    if ([_note.imageName isEqualToString:@""]) {
        hasImageText = @"Add Image";
    } else {
        hasImageText = @"Remove Image";
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What do you want to do with the note?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete it"
                                                    otherButtonTitles:@"Rename", hasImageText, nil];
    
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


- (void)renameNote
{
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_notesStore addImage:info[UIImagePickerControllerOriginalImage] forNote:_note];
}

- (void)manageImageSouce
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose image source."
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"Gallery", nil];
    
    [actionSheet showInView:self.view];
    actionSheet.tag = 300;
}

- (void)showImagePickerType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *ipc = [UIImagePickerController new];
    ipc.sourceType = sourceType;
    ipc.delegate = self;
    
    [self presentViewController:ipc animated:YES completion:nil];
}

- (void)addImage
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self manageImageSouce];
    } else {
        [self showImagePickerType:(UIImagePickerControllerSourceTypePhotoLibrary)];
    }
}

- (void)removeImage
{
    [_notesStore removeImageForNote:_note];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100) {
        
        if (buttonIndex == 0) {
            [self deleteConfirmation];
        } else if(buttonIndex == 1) {
            [self renameNote];
        } else if(buttonIndex == 2) {
            if ([_note.imageName isEqualToString:@""]) {
                [self addImage];
            } else {
                [self removeImage];
            }
        }
    }
    
    if (actionSheet.tag == 200) {
        
        if(buttonIndex == 0) {
            self.noteWasDeleted = YES;
            [self.navigationController popViewControllerAnimated:TRUE];
            [_notesStore removeNote:self.note];
        }
    }
    
    if (actionSheet.tag == 300) {
        
        if (buttonIndex == 0) {
            [self showImagePickerType:UIImagePickerControllerSourceTypeCamera];
        } else if (buttonIndex == 1) {
            [self showImagePickerType:UIImagePickerControllerSourceTypePhotoLibrary];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // maybe forin within SharedStore all tags?
    for (int i = 0; i < [_note.tagsIDs count]; i++) {
        NSString *tagID = _note.tagsIDs[i];
        
        if (![[TagsStore sharedStore] getTagWithID:tagID]) {
            [_note removeTagID:tagID];
        }
    }
    
    [_notesStore saveNote:_note];
    
    [self.tagsCollectionView reloadData];
}

@end
