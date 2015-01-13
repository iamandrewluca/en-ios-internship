//
//  SyncViewController.m
//  ENote
//
//  Created by Andrei Luca on 1/12/15.
//  Copyright (c) 2015 Endava. All rights reserved.
//

#import "SyncViewController.h"
#import "NotebooksStore.h"
#import "AppSync.h"

@interface SyncViewController ()

@end

@implementation SyncViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[AppSync new] sync];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
