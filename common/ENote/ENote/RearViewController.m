//
//  RearViewController.m
//  ENote
//
//  Created by iboicenco on 12/10/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "RearViewController.h"

#import "SWRevealViewController.h"
#import "NotebooksTableViewController.h"

@interface RearViewController()
{
    NSInteger _presentedRow;
}

@end

@implementation RearViewController

@synthesize rearTableView = _rearTableView;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    SWRevealViewController *parentRevealController = self.revealViewController;
    SWRevealViewController *grandParentRevealController = parentRevealController.revealViewController;
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
            style:UIBarButtonItemStylePlain target:grandParentRevealController action:@selector(revealToggle:)];
    
    if ( grandParentRevealController ) {
        NSInteger level=0;
        UIViewController *controller = grandParentRevealController;
        while( nil != (controller = [controller revealViewController]) )
            level++;
        
        NSString *title = [NSString stringWithFormat:@"Detail Level %ld", (long)level];
            
        [self.navigationController.navigationBar addGestureRecognizer:grandParentRevealController.panGestureRecognizer];
        self.navigationItem.leftBarButtonItem = revealButtonItem;
        self.navigationItem.title = title;
    } else {
        self.navigationItem.title = @"Master";
        self.navigationController.view.backgroundColor = [UIColor whiteColor];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    SWRevealViewController *grandParentRevealController = self.revealViewController.revealViewController;
    grandParentRevealController.bounceBackOnOverdraw = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    SWRevealViewController *grandParentRevealController = self.revealViewController.revealViewController;
    grandParentRevealController.bounceBackOnOverdraw = YES;
}


#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	NSInteger row = indexPath.row;
    
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
	}
	
    NSString *text = nil;
	if (row == 0) {
//        UIImageView *cellIcon = [[UIImageView alloc]initWithFrame:CGRectMake(30,5, 40, 45)];
//        cellIcon.image = [UIImage imageNamed:@"cellIcon"];
//        [cell addSubview:cellIcon];
        text = @"Notebooks";
        
	} else if (row == 1) {
        text = @"All Notes";
		
    } else if (row == 2) {
        text = @"Tags";
    }

    
    cell.textLabel.text = NSLocalizedString( text, nil );
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
    SWRevealViewController *revealController = self.revealViewController;
    NSInteger row = indexPath.row;
    
    if ( row == _presentedRow ) {
        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        return;
    } else if (row == 2) {
        [revealController setFrontViewPosition:FrontViewPositionRightMost animated:YES];
        return;
    } else if (row == 3) {
        [revealController setFrontViewPosition:FrontViewPositionRight animated:YES];
        return;
    }

    UIViewController *newFrontController = nil;
    if (row == 0) {
        NotebooksTableViewController *notebooks = [[NotebooksTableViewController alloc] init];
        newFrontController = [[UINavigationController alloc] initWithRootViewController:notebooks];
    }
    
    [revealController pushFrontViewController:newFrontController animated:YES];
    
    _presentedRow = row;  // <- store the presented row
}



@end