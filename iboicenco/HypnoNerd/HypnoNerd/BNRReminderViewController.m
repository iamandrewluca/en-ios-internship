//
//  BNRReminderViewController.m
//  HypnoNerd
//
//  Created by iboicenco on 10/20/14.
//  Copyright (c) 2014 iboicenco. All rights reserved.
//

#import "BNRReminderViewController.h"

@interface BNRReminderViewController ()
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@end

@implementation BNRReminderViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"BNRReminderViewController loaded its view.");
    self.reminder.layer.cornerRadius = 6.0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                       bundle:nibBundleOrNil];
    if (self) {
        // Get the tab bar item
        UITabBarItem *tbi = self.tabBarItem;
        // Give it a label
        tbi.title = @"Reminder";
        // Give it an image
        UIImage *i = [UIImage imageNamed:@"Time.png"];
        tbi.image = i;
    }
    return self;
}

- (IBAction)addReminder:(id)sender
{
    NSDate *date = self.datePicker.date; // logs the picked date.
    NSLog(@"Setting a reminder for %@", date);
    
    UILocalNotification *note = [[UILocalNotification alloc]init];
    note.alertBody = @"Hypnotise Me!";
    note.fireDate = date;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
}


@end
