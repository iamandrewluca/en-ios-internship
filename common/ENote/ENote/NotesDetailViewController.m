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

@interface NotesDetailViewController () <UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

@property (nonatomic) BOOL noteWasDeleted;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsCollectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsCollectionViewBottomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomSpace;

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _addTagTextField) {
        
        if (![textField.text isEqualToString:@""]) {
            Tag *tag = [[TagsStore sharedStore] createTagWithName:textField.text];
            
            BOOL addedTag = [_note addTagID:tag.ID];
            
            if (addedTag) {
                textField.text = @"";
                [_notesStore saveNote:_note];
                [_tagsCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
                [textField resignFirstResponder];
            }
        }
    }
    
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = _note.name;
    
    if (![_note.name isEqualToString:@""]) {
        self.addNotesTextView.text = _note.text;
    }

    _addTagTextField.delegate = self;
    _addTagTextField.returnKeyType = UIReturnKeyDone;
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(actioSheetMenu)];
    self.navigationItem.rightBarButtonItem = menuButton;
    
    _addTagTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _addNotesTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    
    // Tag registering
    UINib *cellNib = [UINib nibWithNibName:@"TagCollectionViewCell" bundle:nil];
    [self.tagsCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"TagCell"];
    
    // get a cell as template for sizing
    _sizingCell = [[cellNib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tagID = [_note.tagsIDs objectAtIndex:indexPath.row];
    [_note removeTagID:tagID];
    
    [self.tagsCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    
//    if ([_tagsCollectionView numberOfItemsInSection:0] == 0) {
//        
//        [UIView animateWithDuration:0.5f animations:^{
//            _tagsCollectionViewHeight.constant = 0;
//            _tagsCollectionViewBottomSpace.constant = 0;
//            
//            [self.view layoutIfNeeded];
//        }];
//    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_note.tagsIDs count];
}

- (void)_configureCell:(TagCollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    NSString *tagID = [[_note tagsIDs] objectAtIndex:indexPath.row];
    
    Tag *tag = [[TagsStore sharedStore] getTagWithID:tagID];
    
    cell.label.text = tag.name;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCell" forIndexPath:indexPath];
    
    [self _configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self _configureCell:_sizingCell forIndexPath:indexPath];
    
    return [_sizingCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

- (void)actioSheetMenu {
    
    [_addNotesTextView resignFirstResponder];
    [_addTagTextField resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What do you want to do with the note?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete it"
                                                    otherButtonTitles:@"Rename", @"Move", nil];
    
    [actionSheet showInView:self.view];
    actionSheet.tag = 100;
}

-(void)deleteConfirmation {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Really delete the selected note?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Yes, delete it"
                                                    otherButtonTitles:nil];
    

    [actionSheet showInView:self.view];
    actionSheet.tag = 200;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
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

 
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
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


// Dismisses the keyboard
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self usePreferredFonts];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(preferredFontsChanged:)
                                                name:UIContentSizeCategoryDidChangeNotification
                                              object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIContentSizeCategoryDidChangeNotification
                                                 object:nil];
    
    if (self.noteWasDeleted == NO) {

        self.note.text = self.addNotesTextView.text;
        [_notesStore saveNote:_note];
    }
}

-(void)preferredFontsChanged:(NSNotification *)notification
{
    [self usePreferredFonts];
}

-(void)usePreferredFonts {
    self.addNotesTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

@end
