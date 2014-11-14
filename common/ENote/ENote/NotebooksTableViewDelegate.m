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

@interface NotebooksTableViewDelegate () <UITextFieldDelegate>
{
    void(^renameNotebook)(void);
}

@end

@implementation NotebooksTableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Notebook *notebook = [[[NotebooksStore sharedStore] allNotebooks] objectAtIndex:indexPath.row];
    
    if (tableView.editing) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter another name"
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.returnKeyType = UIReturnKeyDone;
            textField.placeholder = @"Notebook name";
            textField.delegate = self;
        }];
        
        renameNotebook = ^{
            notebook.name = [[[alert textFields] objectAtIndex:0] text];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       renameNotebook();                                                       
                                                   }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:alert animated:YES completion:nil];
        
    } else {
//        NotesCollectionViewController *notes = [[NotesCollectionViewController alloc] init];
//        notes.notebook = notebook;
//        
//        [self.navigationController pushViewController:notes animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    renameNotebook();
    return YES;
}

@end
