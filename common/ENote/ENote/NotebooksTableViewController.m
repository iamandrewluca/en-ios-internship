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

@interface NotebooksTableViewController ()

@property (nonatomic) NotebooksTableViewDataSource *dataSource;
@property (nonatomic) NotebooksTableViewDelegate *delegate;

@end

@implementation NotebooksTableViewController

- (void)addNewNotebook {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter name"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   
                                                   NSString *nameFromModal = [[alert.textFields objectAtIndex:0] text];
                                                   [[NotebooksStore sharedStore] createNotebookWithName:nameFromModal];
                                                   
                                                   [self.tableView reloadData];
                                                   
                                               }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Notebook name";
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[NotebooksTableViewDataSource alloc] init];
    self.delegate = [[NotebooksTableViewDelegate alloc] init];
    
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
