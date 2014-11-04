//
//  BNRChangeDateController.m
//  BNRHomepwner
//
//  Created by Andrei Luca on 11/4/14.
//  Copyright (c) 2014 Andrei Luca. All rights reserved.
//

#import "BNRChangeDateController.h"

@interface BNRChangeDateController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation BNRChangeDateController

- (void)setItem:(BNRItem *)item
{
    _item = item;
    
    self.navigationItem.title = @"Change Date";
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    BNRItem *item = self.item;
    
    item.dateCreated = self.datePicker.date;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.datePicker.date = self.item.dateCreated;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
