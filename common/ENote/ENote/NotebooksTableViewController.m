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
#import "NotebooksTableViewCell.h"

@interface NotebooksTableViewController ()

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addNewNotebook)];
    
    self.navigationItem.title = @"Notebooks";
    self.navigationItem.rightBarButtonItem = addButton;
    
    UINib *nib = [UINib nibWithNibName:@"NotebooksTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"NotebooksTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[NotebooksStore sharedStore] allNotebooks] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotebooksTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"NotebooksTableViewCell"];
    Notebook *notebook = [[[NotebooksStore sharedStore] allNotebooks] objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = notebook.name;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    cell.datelabel.text = [formatter stringFromDate:notebook.dateCreated];
    [cell.notesNumberLabel setTitle:[NSString stringWithFormat:@"%lu", [notebook.notes count]] forState:UIControlStateNormal];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Notebook *notebook = [[[NotebooksStore sharedStore] allNotebooks] objectAtIndex:indexPath.row];
        
        [[NotebooksStore sharedStore] removeNotebook:notebook];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
