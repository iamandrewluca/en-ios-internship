//
//  RearViewController.m
//  ENote
//
//  Created by Andrei Luca on 12/14/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "RearViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "AllTagsCollectionViewController.h"
#import "AppDelegate.h"
#import "AllNotesTVC.h"
#import "NotebooksTableViewController.h"

@interface RearViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation RearViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    UIViewController *vc = nil;
    
    if ([appDelegate.appNav.topViewController class] != [NotebooksTableViewController class]) {
        [appDelegate.appNav popToRootViewControllerAnimated:NO];
    }
    
    switch (indexPath.row) {
        case 0:
            [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
            break;
            
        case 1:
            vc = [AllNotesTVC new];
            [appDelegate.appNav pushViewController:vc animated:YES];
            break;
            
        case 2:
            vc = [AllTagsCollectionViewController new];
            [appDelegate.appNav pushViewController:vc animated:YES];
            break;
            
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Notebooks";
            break;
            
        case 1:
            cell.textLabel.text = @"All Notes";
            break;
            
        case 2:
            cell.textLabel.text = @"All Tags";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = _imageView.bounds.size.width / 2;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
