//
//  BNRItemsViewController.m
//  BNRHomepwner
//
//  Created by Andrei Luca on 10/16/14.
//  Copyright (c) 2014 Andrei Luca. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRDetailViewController.h"
#import "BNRItemCell.h"
#import "BNRImageStore.h"
#import "BNRImageViewController.h"

@interface BNRItemsViewController () <UIPopoverControllerDelegate>

@property (nonatomic) UIPopoverController *imagePopover;

@end

@implementation BNRItemsViewController

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Items below $50";
            break;
        case 1:
            return @"Items above $50";
            break;
            
        default:
            return @"All items";
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [[[BNRItemStore sharedStore] itemsBelow50] count];
            break;
        case 1:
            return [[[BNRItemStore sharedStore] itemsAbove50] count];
            
        default:
            return [[[BNRItemStore sharedStore] allItems] count];
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] init];
    
    NSArray *items;
    
    if (indexPath.section == 0) {
        items = [[BNRItemStore sharedStore] itemsBelow50];
    } else if (indexPath.section == 1) {
        items = [[BNRItemStore sharedStore] itemsAbove50];
    }
    
    BNRItem *selectedItem = items[indexPath.row];
    
    detailViewController.item = selectedItem;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath.section == destinationIndexPath.section) {
        [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"No more items!";
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        return sourceIndexPath;
    } else {
        return proposedDestinationIndexPath;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSArray *items;
        
        if (indexPath.section == 0) {
            items = [[BNRItemStore sharedStore] itemsBelow50];
        } else if (indexPath.section == 1) {
            items = [[BNRItemStore sharedStore] itemsAbove50];
        }
        
        BNRItem *item = items[indexPath.row];
        
        [[BNRItemStore sharedStore] removeItem:item];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

- (IBAction)addNewItem:(id)sender
{
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    
    NSInteger section = -1;
    NSInteger lastRow = -1;
    
    if (newItem.valueInDollars <= 50) {
        section = 0;
        lastRow = [[[BNRItemStore sharedStore] itemsBelow50] indexOfObject:newItem];
    } else if (newItem.valueInDollars > 50) {
        section = 1;
        lastRow = [[[BNRItemStore sharedStore] itemsAbove50] indexOfObject:newItem];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:lastRow inSection:section];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        navItem.rightBarButtonItem = bbi;
        navItem.leftBarButtonItem = self.editButtonItem;
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNRItemCell" forIndexPath:indexPath];
    
    cell.nameLabel.font = [UIFont fontWithName:@"Arial" size:20.0];
    
    NSArray *items;
    
    if (indexPath.section == 0) {
        items = [[BNRItemStore sharedStore] itemsBelow50];
    } else if (indexPath.section == 1) {
        items = [[BNRItemStore sharedStore] itemsAbove50];
    }
    
    BNRItem *item = items[indexPath.row];
    
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
    
    if (item.valueInDollars > 50) {
        cell.valueLabel.textColor = [UIColor greenColor];
    } else if (item.valueInDollars <= 50) {
        cell.valueLabel.textColor = [UIColor redColor];
    } else {
        cell.valueLabel.textColor = [UIColor blackColor];
    }
    
    cell.thumbnailView.image = item.thumbnail;
    
    __weak BNRItemCell *weakCell = cell;
    
    cell.actionBlock = ^{
        NSLog(@"Going to show image for %@", item);
        
        BNRItemCell *strongCell = weakCell;
        
        if ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomUnspecified) {
            
            NSString *itemKey = item.itemKey;
            UIImage *img = [[BNRImageStore sharedStore] imageForKey:itemKey];
            
            if (!img) {
                return;
            }
            
            CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds fromView:strongCell.thumbnailView];
            
            BNRImageViewController *ivc = [[BNRImageViewController alloc] init];
            ivc.image = img;
            
            self.imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
            self.imagePopover.delegate = self;
            self.imagePopover.popoverContentSize = CGSizeMake(300, 300);
            
            [self.imagePopover presentPopoverFromRect:rect
                                               inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
            
        }
    };
    
    return cell;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePopover = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [backgroundImage setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = backgroundImage;
    
    UINib *nib = [UINib nibWithNibName:@"BNRItemCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BNRItemCell"];
    
}

@end
