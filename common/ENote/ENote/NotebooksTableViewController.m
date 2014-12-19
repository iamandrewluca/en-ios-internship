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
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

@interface NotebooksTableViewController () <UITableViewDelegate, UIGestureRecognizerDelegate> {
    NSIndexPath *selectedNotebookIndexPath;
    UIImageView *emptyTableViewBackground;
}

@property (nonatomic) NotebooksTableViewDataSource *dataSource;

@end

@implementation NotebooksTableViewController

- (void)addNewNotebook {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter new name"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.returnKeyType = UIReturnKeyDone;
        textField.placeholder = @"Notebook name";
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   
                                                   NSString *nameFromModal = [[alert.textFields objectAtIndex:0] text];
                                                   
                                                   if (![nameFromModal isEqualToString:@""]) {
                                                       
                                                       [[NotebooksStore sharedStore] createNotebookWithName:nameFromModal];
                                                       NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                                                       [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                                                   }
                                               }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)leftBarButtonItemPressed:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup Data Source
    self.dataSource = [[NotebooksTableViewDataSource alloc] init];
    self.tableView.dataSource = self.dataSource;
    
    // Setup navigationItem left, center, right items
    self.navigationItem.leftBarButtonItem = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftBarButtonItemPressed:)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addNewNotebook)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.title = @"Notebooks";

    
    // Register Cell for TableView
    UINib *nib = [UINib nibWithNibName:@"NotebooksTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"NotebooksTableViewCell"];
    
    // Setup tableView background pattern
    UIImage *pattern = [UIImage imageNamed:@"BackgroundPattern"];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:pattern];
    
    // Prepare tableView empty background
    UIImage *image = [UIImage imageNamed:@"addSomeNotebooks"];
    emptyTableViewBackground = [[UIImageView alloc] initWithImage:image];
    [emptyTableViewBackground setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewNotebook)];
    [emptyTableViewBackground addGestureRecognizer:tap];
    
    self.tableView.backgroundView = [[UIView alloc] initWithFrame:self.tableView.frame];
    [self.tableView.backgroundView addSubview:emptyTableViewBackground];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint pointInView = [gestureRecognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:pointInView];
    
    if (indexPath && gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter another name"
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.returnKeyType = UIReturnKeyDone;
            textField.placeholder = @"Notebook name";
        }];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       
                                                       NSString *nameFromModal = [[[alert textFields] objectAtIndex:0] text];
                                                       
                                                       if (![nameFromModal isEqualToString:@""]) {
                                                           Notebook *notebook = [[[NotebooksStore sharedStore] allNotebooks] objectAtIndex:indexPath.row];
                                                           
                                                           notebook.name = nameFromModal;
                                                           
                                                           [[NotebooksStore sharedStore] saveNotebook:notebook];
                                                           
                                                           [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                                                       }
                                                   }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
        
        [alert addAction:cancel];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Center emptyTableViewBackground every time layout will change
    [emptyTableViewBackground setCenter:CGPointMake(self.tableView.center.x,
                                                    self.tableView.center.y -
                                                    emptyTableViewBackground.image.size.height / 2 -
                                                    emptyTableViewBackground.image.size.width / 2 )];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (selectedNotebookIndexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[selectedNotebookIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotesCollectionViewController *notes = [[NotesCollectionViewController alloc] initWithNibName:@"NotesCollectionViewController" bundle:nil];
    
    Notebook *notebook = [[[NotebooksStore sharedStore] allNotebooks] objectAtIndex:indexPath.row];
    notes.notesStore = [[NotebooksStore sharedStore] notesStoreForNotebook:notebook];
    
    selectedNotebookIndexPath = indexPath;
    
    [[self navigationController] pushViewController:notes animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

@end
