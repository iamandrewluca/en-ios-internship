//
//  NotebooksTableViewController.m
//  ENote
//
//  Created by Andrei Luca on 11/10/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotebooksTableViewController.h"
#import "NotebooksStore.h"
#import "Notebook.h"
#import "NotebooksTableViewDataSource.h"
#import "NotebooksTableViewDelegate.h"

@class NotesCollectionViewController;

@interface NotebooksTableViewController () <UITextFieldDelegate>
{
    void(^addNotebook)(void);
}

@property (nonatomic) NotebooksTableViewDataSource *dataSource;
@property (nonatomic) NotebooksTableViewDelegate *delegate;

@end

@implementation NotebooksTableViewController

- (void)addNewNotebook {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter new name"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.returnKeyType = UIReturnKeyDone;
        textField.placeholder = @"Notebook name";
        textField.delegate = self;
    }];
    
    __weak UITableView *weakTableView = self.tableView;
    addNotebook = ^{
        NSString *nameFromModal = [[alert.textFields objectAtIndex:0] text];
        Notebook *notebook = [[NotebooksStore sharedStore] createNotebookWithName:nameFromModal];
        
        NSInteger lastRow = [[[NotebooksStore sharedStore] allNotebooks] indexOfObject:notebook];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:lastRow inSection:0];
        
        [weakTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    };
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   addNotebook();
                                               }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    addNotebook();
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[NotebooksTableViewDataSource alloc] init];
    self.delegate = [[NotebooksTableViewDelegate alloc] init];
    
    self.delegate.parent = self;
    
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.delegate;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addNewNotebook)];
    
    self.navigationItem.title = @"Notebooks";
    self.navigationItem.rightBarButtonItem = addButton;
    
    UINib *nib = [UINib nibWithNibName:@"NotebooksTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"NotebooksTableViewCell"];
}

@end
