//
//  AddTagsViewController.m
//  ENote
//
//  Created by Andrei Luca on 12/19/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "UIViewController+MJPopupViewController.h"
#import "AddTagsViewController.h"
#import "TagsStore.h"
#import "Tag.h"

@interface AddTagsViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *foundTags;

@end

@implementation AddTagsViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.pctrl.collectionView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Add Tags";
    
    [_textField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    _textField.returnKeyType = UIReturnKeyDone;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_textField becomeFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_foundTags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }

    cell.textLabel.text = [[_foundTags objectAtIndex:indexPath.row] name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tag *tag = [_foundTags objectAtIndex:indexPath.row];
    
    [_note addTagID:tag.ID];
    [_notesStore saveNote:_note];
    [self.pctrl.collectionView reloadData];
    [_textField resignFirstResponder];
    [self.pctrl dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    _foundTags = [[TagsStore sharedStore] tagsWhichContainText:textField.text];
    [self.tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    Tag *tag = [[TagsStore sharedStore] createTagWithName:textField.text];
    
    [_note addTagID:tag.ID];
    [_notesStore saveNote:_note];
    
    [textField resignFirstResponder];
    [self.pctrl dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    
    return YES;
}

@end
