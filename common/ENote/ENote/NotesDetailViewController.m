//
//  NotesDetailViewController.m
//  ENote
//
//  Created by iboicenco on 11/13/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotesDetailViewController.h"
#import "Note.h"

@interface NotesDetailViewController () <UITextViewDelegate>
@property (weak, nonatomic) UINavigationBar *navigationBar;
@end

@implementation NotesDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.note.name;
    self.titleTextField.text = _note.name;
    self.noteTextView.text = _note.text;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.75f alpha:1.0f];
    
    // noteTextView customization
    self.noteTextView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:134.0/255.0 blue:13.0/255.0 alpha:1.0];
    self.noteTextView.layer.borderColor = [UIColor blackColor].CGColor;
    self.noteTextView.layer.borderWidth = 1.0f;
    self.noteTextView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.noteTextView.layer.shadowRadius = 18.0f;
    self.noteTextView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.noteTextView.layer.shadowOpacity = 0.8f;
    self.noteTextView.layer.cornerRadius = 4.0f;


    // the nav bar's custom Done button right view
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem = addButton;
    
    
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
    [self usePreferredFonts]; // sync up with the "world".
    
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
    
}

-(void)preferredFontsChanged:(NSNotification *)notification
{
    [self usePreferredFonts];
}

-(void)usePreferredFonts {
    self.noteTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

@end
