//
//  NotebooksTableViewDataSource.h
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NotebooksTableViewController.h"

@interface NotebooksTableViewDataSource : NSObject <UITableViewDataSource>
@property (nonatomic) NotebooksTableViewController *ctrl;
@end
