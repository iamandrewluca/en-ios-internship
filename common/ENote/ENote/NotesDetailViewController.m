//
//  NotesDetailViewController.m
//  ENote
//
//  Created by iboicenco on 11/13/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotesDetailViewController.h"
#import "Note.h"
#import "MapPinViewController.h"
#import "NoteImagesCollectionViewController.h"
#import "ImagesStore.h"
#import "NotesCollectionViewController.h"
#import "NoteTagsCollectionViewController.h"
#import "TagsStore.h"

@interface NotesDetailViewController () <UINavigationControllerDelegate>

#pragma mark - @Properties
@property (nonatomic) BOOL noteWasDeleted;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomSpace;
@property (weak, nonatomic) IBOutlet UITextView *addNotesTextView;
@property (weak, nonatomic) IBOutlet UIView *noteImagesPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *noteTagsPlaceholder;
@property (nonatomic) NoteImagesCollectionViewController *imagesCVC;
@property (nonatomic) NoteTagsCollectionViewController *tagsCVC;
@end

@implementation NotesDetailViewController

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = _note.name;
    
    self.addNotesTextView.text = _note.text;
    
    _addNotesTextView.layer.cornerRadius = 5.0f;
    _addNotesTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    
    // menu button
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"threeDots"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(actioSheetMenu)];
    // location button
    UIBarButtonItem *location = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"location"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(MapKitLocation)];
    
    NSArray *buttons = @[menuButton, location];
    self.navigationItem.rightBarButtonItems = buttons;
    
    [self setupNoteTagsPlaceholder];
    [self setupNoteImagesPlaceholder];
}

- (void)setupNoteTagsPlaceholder
{
    _tagsCVC = [[NoteTagsCollectionViewController alloc] initWithNibName:@"NoteTagsCollectionViewController" bundle:nil];
    _tagsCVC.note = _note;
    _tagsCVC.notesStore = _notesStore;
    _tagsCVC.view.frame = _noteTagsPlaceholder.bounds;
    [_tagsCVC willMoveToParentViewController:self];
    [self addChildViewController:_tagsCVC];
    [_noteTagsPlaceholder addSubview:_tagsCVC.view];
    [_tagsCVC didMoveToParentViewController:self];
}

- (void)setupNoteImagesPlaceholder
{
    [_noteImagesPlaceholder.layer setMasksToBounds:NO];
    
    _imagesCVC = [[NoteImagesCollectionViewController alloc] initWithNibName:@"NoteImagesCollectionViewController" bundle:nil];
    
    _imagesCVC.note = _note;
    _imagesCVC.notesStore = _notesStore;
    
    _imagesCVC.view.frame = _noteImagesPlaceholder.bounds;
    [_imagesCVC willMoveToParentViewController:self];
    [self addChildViewController:_imagesCVC];
    [_noteImagesPlaceholder addSubview:_imagesCVC.view];
    [_imagesCVC didMoveToParentViewController:self];
    
    if (![_note.imagesIDs count]) {
        _noteImagesHeightConstraint.constant = 0;
        _noteImagesTopConstraint.constant = 0;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeNoteTextView:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeNoteTextView:) name:UIKeyboardDidHideNotification object:nil];
    
    // maybe forin within SharedStore all tags?
    for (int i = 0; i < [_note.tagsIDs count]; i++) {
        NSString *tagID = _note.tagsIDs[i];
        
        if (![[TagsStore sharedStore] getTagWithID:tagID]) {
            [_note removeTagID:tagID];
        }
    }
    
    [_notesStore saveNote:_note];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.noteWasDeleted == NO) {
        self.note.text = self.addNotesTextView.text;
        [_notesStore saveNote:_note];
    }
}

-(void)MapKitLocation
{
    MapPinViewController *mapKitVC = [[MapPinViewController alloc]init];
    [self.navigationController pushViewController:mapKitVC animated:YES];
}

#pragma mark - <UIActionSheetDelegate>
- (void)actioSheetMenu
{
    [_addNotesTextView resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What do you want to do with the note?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete note"
                                                    otherButtonTitles:@"Rename", @"Add Image", @"Add Location", nil];
    
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

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100) {
        if (buttonIndex == 0) {
            [self deleteConfirmation];
        } else if(buttonIndex == 1) {
            [self renameNote];
        } else if(buttonIndex == 2) {
            [self addImage];
        } else if (buttonIndex == 3) {
            [self MapKitLocation];
        }
    }
    
    if (actionSheet.tag == 200) {
        if(buttonIndex == 0) {
            [_notesStore removeNote:self.note];
            self.noteWasDeleted = YES;
            [self.navigationController popViewControllerAnimated:TRUE];
            ((NotesCollectionViewController *)[self.navigationController topViewController]).noteWasDeleted = YES;
        }
    }
    
    if (actionSheet.tag == 300) {
        if (buttonIndex == 0) {
            [_imagesCVC showImagePickerType:UIImagePickerControllerSourceTypeCamera];
        } else if (buttonIndex == 1) {
            [_imagesCVC showImagePickerType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }
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

- (void)addImage
{
    [_imagesCVC setEditing:NO];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self manageImageSouce];
    } else {
        [_imagesCVC showImagePickerType:(UIImagePickerControllerSourceTypePhotoLibrary)];
    }
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

@end
