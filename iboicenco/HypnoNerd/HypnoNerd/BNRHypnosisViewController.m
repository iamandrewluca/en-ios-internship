//
//  BNRHypnosisViewController.m
//  HypnoNerd
//
//  Created by iboicenco on 10/16/14.
//  Copyright (c) 2014 iboicenco. All rights reserved.
//

#import "BNRHypnosisViewController.h"
#import "BNRHypnosisView.h"

@interface BNRHypnosisViewController () <UITextFieldDelegate>

@end

@implementation BNRHypnosisViewController 

-(void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"BNRHypnosisViewController loaded its view.");
    self.segmentedControl.layer.cornerRadius = 6.0;
    
    CGRect textFieldRect = CGRectMake(40, 70, 240, 30);
    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldRect];
    // Setting the border style on the text field will allow us to see it more easily
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"Hypnotize me!";
    textField.returnKeyType = UIReturnKeyDone;
    
    // There will be a warning on this line. We will discuss it shortly.
    textField.delegate = self; // BNRHypnosisViewController as UITextField delegate
    
    [self.view addSubview:textField];

}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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

- (IBAction)changeColor:(id)sender
{
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //NSLog(@"%@", textField.text);
    [self drawHypnoticMessage:textField.text];
    
    textField.text = @"";
    [textField resignFirstResponder];
    
    return YES;
}

-(void)drawHypnoticMessage:(NSString *)message
{
    for (int i = 0; i < 20; i++) {
        UILabel *msgLabel = [[UILabel alloc]init];
        
        // Configure the label's colors and text
        msgLabel.backgroundColor = [UIColor clearColor];
        msgLabel.textColor = [UIColor redColor];
        msgLabel.text = message;
        
        // This method resizes the label, which will be relative
        // to the text that it is displaying
        [msgLabel sizeToFit];
        
        // Get a random x value that fits within the hypnosis view's width
        int width = (int)(self.view.bounds.size.width - msgLabel.bounds.size.width);
        int x = arc4random() % width;
        
        // Get a random y value that fits within the hypnosis view's height
        int height = (int)(self.view.bounds.size.height - msgLabel.bounds.size.height);
        int y = arc4random() % height;
        
        // Update the label's frame
        CGRect frame = msgLabel.frame;
        frame.origin = CGPointMake(x, y);
        msgLabel.frame = frame;
        
        // Add the label to the hierarchy
        [self.view addSubview:msgLabel];
        
        UIInterpolatingMotionEffect *motionEffect;
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        [msgLabel addMotionEffect:motionEffect];
        
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        [msgLabel addMotionEffect:motionEffect];
        
        }
    
}

@end














