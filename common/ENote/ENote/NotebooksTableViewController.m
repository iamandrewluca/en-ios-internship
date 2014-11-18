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
#import "NotesCollectionViewController.h"

@interface NotebooksTableViewController () <UITextFieldDelegate, UITableViewDelegate>

@property (nonatomic) UIAlertController *alert;
@property (nonatomic) NotebooksTableViewDataSource *dataSource;

@end

@implementation NotebooksTableViewController

- (void)renameNotebookAtRow:(NSInteger)row {
    
    NSString *nameFromModal = [[[self.alert textFields] objectAtIndex:0] text];
    
    if (![nameFromModal isEqualToString:@""]) {
        Notebook *notebook = [[[NotebooksStore sharedStore] allNotebooks] objectAtIndex:row];
        notebook.name = nameFromModal;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
        [[NotebooksStore sharedStore] saveNotebooks];
    }
}

- (void)createNotebook {
    
    NSString *nameFromModal = [[self.alert.textFields objectAtIndex:0] text];
    
    if (![nameFromModal isEqualToString:@""]) {
        Notebook *notebook = [[NotebooksStore sharedStore] createNotebookWithName:nameFromModal];
        
        NSInteger lastRow = [[[NotebooksStore sharedStore] allNotebooks] indexOfObject:notebook];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:lastRow inSection:0];
        
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        
        [[NotebooksStore sharedStore] saveNotebooks];
    }
}

- (void)addNewNotebook {
    
    self.alert = [UIAlertController alertControllerWithTitle:@"Enter new name"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [self.alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.returnKeyType = UIReturnKeyDone;
        textField.placeholder = @"Notebook name";
        textField.tag = -1;
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   [self createNotebook];
                                               }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    
    [self.alert addAction:cancel];
    [self.alert addAction:ok];
    
    
    
    [self presentViewController:self.alert animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == -1) {
        [self createNotebook];
    } else {
        [self renameNotebookAtRow:textField.tag];
    }
    
    [self.alert dismissViewControllerAnimated:YES completion:nil];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[NotebooksTableViewDataSource alloc] init];
    
    self.tableView.dataSource = self.dataSource;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addNewNotebook)];
    
    self.navigationItem.title = @"Notebooks";
    self.navigationItem.rightBarButtonItem = addButton;
    
    UINib *nib = [UINib nibWithNibName:@"NotebooksTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"NotebooksTableViewCell"];
}

#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.editing) {
        
        self.alert = [UIAlertController alertControllerWithTitle:@"Enter another name"
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [self.alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.returnKeyType = UIReturnKeyDone;
            textField.placeholder = @"Notebook name";
            textField.tag = indexPath.row;
        }];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       [self renameNotebookAtRow:indexPath.row];
                                                   }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
        
        [self.alert addAction:cancel];
        [self.alert addAction:ok];
        
        [self presentViewController:self.alert animated:YES completion:nil];
        
    } else {
        
        NotesCollectionViewController *notes = [[NotesCollectionViewController alloc] initWithNibName:@"NotesCollectionViewController" bundle:nil];
        
        Notebook *notebook = [[[NotebooksStore sharedStore] allNotebooks] objectAtIndex:indexPath.row];
        
        notes.notebook = notebook;
        
        [[self navigationController] pushViewController:notes animated:YES];
    }
}

@end
