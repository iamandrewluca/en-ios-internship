//
//  BNRCoursesViewController.m
//  BNRNerdFeed
//
//  Created by Andrei Luca on 10/28/14.
//  Copyright (c) 2014 Andrei Luca. All rights reserved.
//

#import "BNRCoursesViewController.h"

@interface BNRCoursesViewController () <UITableViewDelegate>

@property (nonatomic) NSURLSession *session;

@end

@implementation BNRCoursesViewController

#pragma mark Other

- (void)fetchFeed
{
    NSString *requestString = @"http://bookapi.bignerdranch.com/courses.json";
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", json);
        
    }];
    
    [dataTask resume];
}

#pragma  mark Init

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        
        self.navigationItem.title = @"BNRCourses";
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
        
        [self fetchFeed];
        
    }
    
    return self;
}

#pragma mark TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
