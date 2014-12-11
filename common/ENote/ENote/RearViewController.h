//
//  RearViewController.h
//  ENote
//
//  Created by iboicenco on 12/10/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RearViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *rearTableView;

@end