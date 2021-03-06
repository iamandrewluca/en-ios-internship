//
//  NotebooksTableViewDataSource.m
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NotebooksTableViewDataSource.h"
#import <UIKit/UIKit.h>
#import "NotebooksStore.h"
#import "NotebooksTableViewCell.h"
#import "Notebook.h"
#import "NotesStore.h"
#import "NSDate+IfDay.h"

@interface NotebooksTableViewDataSource ()
@end


@implementation NotebooksTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[NotebooksStore sharedStore] allNotebooks] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView numberOfRowsInSection:0] > 0) {
        if (![[[tableView.backgroundView subviews] firstObject] isHidden]) {
            [[[tableView.backgroundView subviews] firstObject] setHidden:YES];
        }
    }
    
    NotebooksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotebooksTableViewCell"];

    Notebook *notebook = [[[NotebooksStore sharedStore] allNotebooks] objectAtIndex:indexPath.row];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height - 1, tableView.bounds.size.width, 1)];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:bottomLineView];
    
    cell.nameLabel.text = notebook.name;
    
    if ([notebook.dateCreated isToday]) {
        cell.datelabel.text = @"Today";
    } else if (![notebook.dateCreated isBehindTodayWithDaysMoreThen:3]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE"];
        cell.datelabel.text = [dateFormatter stringFromDate:notebook.dateCreated];
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        cell.datelabel.text = [dateFormatter stringFromDate:notebook.dateCreated];
    }
    
    cell.notesNumberLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[notebook.notesIDs count]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Notebook *notebook = [[[NotebooksStore sharedStore] allNotebooks] objectAtIndex:indexPath.row];
        
        [[NotebooksStore sharedStore] removeNotebook:notebook];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if ([tableView numberOfRowsInSection:0] == 0) {
            if ([[[tableView.backgroundView subviews] firstObject] isHidden]) {
                [[[tableView.backgroundView subviews] firstObject] setHidden:NO];
            }
        }
    }
}

@end