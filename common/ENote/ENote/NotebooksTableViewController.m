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

@interface NotebooksTableViewController () <UITableViewDelegate>

@property (nonatomic) UIAlertController *alert;
@property (nonatomic) NotebooksTableViewDataSource *dataSource;

@end

@implementation NotebooksTableViewController

- (void)addNewNotebook {
    
    self.alert = [UIAlertController alertControllerWithTitle:@"Enter new name"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [self.alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.returnKeyType = UIReturnKeyDone;
        textField.placeholder = @"Notebook name";
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   
                                                   NSString *nameFromModal = [[self.alert.textFields objectAtIndex:0] text];
                                                   
                                                   if (![nameFromModal isEqualToString:@""]) {
                                                       Notebook *notebook = [[Notebook alloc] initWithName:nameFromModal];
                                                       
                                                       [[NotebooksStore sharedStore] addStoreItem:notebook];
                                                       
                                                       NSInteger lastRow = [[[NotebooksStore sharedStore] allStoreItems] indexOfObject:notebook];
                                                       
                                                       NSIndexPath *indexPath = [NSIndexPath indexPathForItem:lastRow inSection:0];
                                                       
                                                       [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                                                   }
                                               }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    
    [self.alert addAction:cancel];
    [self.alert addAction:ok];
    
    [self presentViewController:self.alert animated:YES completion:nil];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
        }];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       
                                                       NSString *nameFromModal = [[[self.alert textFields] objectAtIndex:0] text];
                                                       
                                                       if (![nameFromModal isEqualToString:@""]) {
                                                           Notebook *notebook = [[[NotebooksStore sharedStore] allStoreItems] objectAtIndex:indexPath.row];
                                                           
                                                           notebook.name = nameFromModal;
                                                           
                                                           [[NotebooksStore sharedStore] saveStoreItem:notebook];
                                                           
                                                           [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                                                       }
                                                   }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
        
        [self.alert addAction:cancel];
        [self.alert addAction:ok];
        
        [self presentViewController:self.alert animated:YES completion:nil];
        
    } else {
        
        NotesCollectionViewController *notes = [[NotesCollectionViewController alloc] initWithNibName:@"NotesCollectionViewController" bundle:nil];
        
        Notebook *notebook = [[[NotebooksStore sharedStore] allStoreItems] objectAtIndex:indexPath.row];
        
        notes.notebook = notebook;
        
        [[self navigationController] pushViewController:notes animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

@end
