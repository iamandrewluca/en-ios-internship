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
    self.segmentedControl.layer.cornerRadius = 6.0;

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

- (IBAction)changeColor:(id)sender {
    BNRHypnosisView *hypnosisView = (BNRHypnosisView *)self.view;
    UISegmentedControl *s = (UISegmentedControl *)sender;
    
    NSUInteger index = [s selectedSegmentIndex];
    if (index == 0) {
        hypnosisView.circleColor = [UIColor redColor];
    }
    else if (index == 1) {
        hypnosisView.circleColor = [UIColor blueColor];
    }
    else if (index == 2) {
        hypnosisView.circleColor = [UIColor greenColor];
    }
    else if (index == 3)
        hypnosisView.circleColor = [UIColor grayColor];
    
}


@end
