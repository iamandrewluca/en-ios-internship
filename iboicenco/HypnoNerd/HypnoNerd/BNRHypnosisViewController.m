//
//  BNRHypnosisViewController.m
//  HypnoNerd
//
//  Created by iboicenco on 10/16/14.
//  Copyright (c) 2014 iboicenco. All rights reserved.
//

#import "BNRHypnosisViewController.h"
#import "BNRHypnosisView.h"

@implementation BNRHypnosisViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"BNRHypnosisViewController loaded its view.");
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Hypnotize";
        // This will use Hypno@2x.png on retina display devices
        UIImage *i = [UIImage imageNamed:@"Hypno.png"];
        self.tabBarItem.image = i;
    }
    return self;
}

-(void)loadView
{
    // Create a view
    BNRHypnosisView *backgroundView = [[BNRHypnosisView alloc] init];
    // Set it as *the* view of this view controller
    self.view = backgroundView;
}

@end
