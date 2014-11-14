//
//  NotebooksTableViewDelegate.m
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotebooksTableViewDelegate.h"
#import <UIKit/UIKit.h>
#import "Notebook.h"
#import "NotebooksStore.h"

@interface NotebooksTableViewDelegate ()
@end

@implementation NotebooksTableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Notebook *notebook = [[[NotebooksStore sharedStore] allNotebooks] objectAtIndex:indexPath.row];
    
    if (tableView.editing) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter another name"
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       
                                                       NSString *nameFromModal = [[alert.textFields objectAtIndex:0] text];
                                                       notebook.name = nameFromModal;
                                                       
                                                       [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];                                                       
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
        
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:alert animated:YES completion:nil];
        
    } else {
//        NotesCollectionViewController *notes = [[NotesCollectionViewController alloc] init];
//        notes.notebook = notebook;
//        
//        [self.navigationController pushViewController:notes animated:YES];
    }
}

@end
