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
    self.navigationItem.title = self.note.text;
    self.view.backgroundColor = [UIColor colorWithWhite:0.75f alpha:1.0f];
    
    // noteTextView customization
    self.noteTextView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:134.0/255.0 blue:13.0/255.0 alpha:1.0];
    self.noteTextView.layer.borderColor = [UIColor blackColor].CGColor;
    self.noteTextView.layer.borderWidth = 1.0f;
    self.noteTextView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.noteTextView.layer.shadowRadius = 18.0f;
    self.noteTextView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.noteTextView.layer.shadowOpacity = 0.8f;
    
    // Save text
    self.string = [[NSUserDefaults standardUserDefaults] objectForKey:@"text"];
    self.noteTextView.text = self.string;
    self.noteTextView.delegate = self;
    
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateString) userInfo:nil repeats:YES];
    
    // Customize text
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc]initWithString:self.outlineButton.currentTitle];
    [title setAttributes:@{ NSStrokeWidthAttributeName:@-3,
                            NSStrokeColorAttributeName:self.outlineButton.tintColor }
                   range:NSMakeRange(0, [title length])];
    [self.outlineButton setAttributedTitle:title forState:UIControlStateNormal];
    
    self.redRoundCorner.layer.cornerRadius = 6.0f;
    self.greenRoundCorner.layer.cornerRadius = 6.0f;
    self.orangeRoundCorner.layer.cornerRadius = 6.0f;
    self.purpleRoundCorner.layer.cornerRadius = 6.0f;
    
    self.outlineButton.layer.cornerRadius = 6.0f;
    self.unoutlineButton.layer.cornerRadius = 6.0f;
    self.decolor.layer.cornerRadius = 6.0f;
    
    // self.noteTextView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:134.0/255.0 blue:13.0/255.0 alpha:1.0];
    self.noteTextView.layer.cornerRadius = 4.0f;
    
    // the nav bar's custom Done button right view
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem = addButton;
    
    
}

// Saves the updated string in the user defaults
-(void)updateString{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.noteTextView.text forKey:@"text"];
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
    
    //self.noteTextView.text = self.noteTextView.text;

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIContentSizeCategoryDidChangeNotification
                                                 object:nil];
    
    self.note.text = self.noteTextView.text;
    
}

-(void)preferredFontsChanged:(NSNotification *)notification
{
    [self usePreferredFonts];
}

-(void)usePreferredFonts {
    self.noteTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    //self.headline.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
}

- (IBAction)changeBodySelectionColorToMatchBackgroundOfButton:(UIButton *)sender {
    [self.noteTextView.textStorage addAttribute:NSForegroundColorAttributeName value:sender.backgroundColor range:self.noteTextView.selectedRange];
}

- (IBAction)Decolor:(UIButton *)sender {
    [self.noteTextView.textStorage removeAttribute:NSForegroundColorAttributeName range:self.noteTextView.selectedRange];
}

- (IBAction)outlineBodySelection {
    [self.noteTextView.textStorage addAttributes:@{ NSStrokeWidthAttributeName:@-3,
                                            NSStrokeColorAttributeName:[UIColor blackColor] }
                                   range:self.noteTextView.selectedRange];
}

- (IBAction)unoutlineBodySelection {
    [self.noteTextView.textStorage removeAttribute:NSStrokeWidthAttributeName range:self.noteTextView.selectedRange];
}

@end
