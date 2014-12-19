//
//  AddTagsViewController.m
//  ENote
//
//  Created by Andrei Luca on 12/19/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "AddTagsViewController.h"
#import "TagsStore.h"
#import "Tag.h"

@interface AddTagsViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottom;

@property (nonatomic) NSArray *foundTags;

@end

@implementation AddTagsViewController

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeTableView:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeTableView:) name:UIKeyboardDidHideNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)resizeTableView:(NSNotification *)notification
{
    if (notification.name == UIKeyboardDidShowNotification) {
        NSDictionary *keyboardInfo = [notification userInfo];
        NSValue *keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
        
        _tableViewBottom.constant = 8 + keyboardFrameBeginRect.size.height;
        
    } else if (notification.name == UIKeyboardDidHideNotification) {
        _tableViewBottom.constant = 8;
    }
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [_textField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
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
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}

@end
