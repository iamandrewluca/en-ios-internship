//
//  NotesDetailViewController.m
//  ENote
//
//  Created by iboicenco on 11/13/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotesDetailViewController.h"
#import "NotesCollectionViewController.h"
#import "Note.h"

@interface NotesDetailViewController () <UITextViewDelegate>
@property (weak, nonatomic) UINavigationBar *navigationBar;
@end

@implementation NotesDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = _note.name;
    self.titleTextField.text = _note.name;
    self.noteTextView.text = _note.text;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.75f alpha:1.0f];
    
    // noteTextView customization
    self.noteTextView.backgroundColor = [UIColor whiteColor];
    self.noteTextView.layer.borderColor = [UIColor blackColor].CGColor;
    self.noteTextView.layer.borderWidth = 1.0f;
    self.noteTextView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.noteTextView.layer.shadowRadius = 18.0f;
    self.noteTextView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.noteTextView.layer.shadowOpacity = 0.8f;
    self.noteTextView.layer.cornerRadius = 4.0f;
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(actioSheetMenu)];
    self.navigationItem.rightBarButtonItem = menuButton;
}

- (void)actioSheetMenu {
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
    
    self.note.name = self.titleTextField.text;
    self.note.text = self.noteTextView.text;
    [_notesStore saveNote:_note];

}

-(void)preferredFontsChanged:(NSNotification *)notification
{
    [self usePreferredFonts];
}

-(void)usePreferredFonts {
    self.noteTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

@end
