//
//  BNRHypnosisViewController.m
//  BNRHypnoNerd
//
//  Created by Andrei Luca on 10/13/14.
//  Copyright (c) 2014 Andrei Luca. All rights reserved.
//

#import "BNRHypnosisViewController.h"
#import "BNRHypnosisView.h"

@interface BNRHypnosisViewController () <UITextFieldDelegate>

@property (nonatomic) UITextField *textField;

@end

@implementation BNRHypnosisViewController

- (void)drawHypnoticMessage:(NSString *)message
{
    for (int i = 0; i < 50; i++) {
        
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.text = message;
        [messageLabel sizeToFit];
        
        int width = (int)(self.view.bounds.size.width - messageLabel.bounds.size.width);
        int x = arc4random() % width;
        
        int height = (int)(self.view.bounds.size.height - messageLabel.bounds.size.height);
        int y = arc4random() % height;
        
        CGRect frame = messageLabel.frame;
        frame.origin = CGPointMake(x, y);
        messageLabel.frame = frame;
        
        [self.view addSubview:messageLabel];
        
        messageLabel.alpha = 0.0;
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             messageLabel.alpha = 1.0;
                         } completion:NULL];
        
        [UIView animateKeyframesWithDuration:1.0
                                       delay:0.0
                                     options:0
                                  animations:^{
                                      
                                      [UIView addKeyframeWithRelativeStartTime:0.0
                                                              relativeDuration:0.8
                                                                    animations:^{
                                                                        messageLabel.center = self.view.center;
                                                                    }];
                                      
                                      [UIView addKeyframeWithRelativeStartTime:0.8
                                                              relativeDuration:0.2
                                                                    animations:^{
                                                                        int x = arc4random() % width;
                                                                        int y = arc4random() % height;
                                                                        messageLabel.center = CGPointMake(x, y);
                                                                    }];
                                  } completion:^(BOOL finished) {
                                      NSLog(@"Animation Finished");
                                  }];
        
        // Not working on simulation device
        UIInterpolatingMotionEffect *motionEffect;
        
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        
        [messageLabel addMotionEffect:motionEffect];
        
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        
        [messageLabel addMotionEffect:motionEffect];

    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self drawHypnoticMessage:textField.text];
    
    textField.text = @"";
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:2.0
                          delay:0.0
         usingSpringWithDamping:0.25
          initialSpringVelocity:0.0
                        options:0
                     animations:^{
                         
                         CGRect frame = CGRectMake(40, 70, 240, 30);
                         self.textField.frame = frame;
                         
                     } completion:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISegmentedControl *sc = [[UISegmentedControl alloc] initWithItems:@[@"Red", @"Green", @"Blue"]];
    
    sc.tintColor = [UIColor blackColor];
    
    CGRect scFrame = CGRectMake(self.view.bounds.origin.x + 8,
                                self.view.bounds.size.height - 88,
                                self.view.bounds.size.width - 16, 30);
    sc.frame = scFrame;
    
    [sc addTarget:self action:@selector(colorSelected:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sc];
}

- (void)colorSelected:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
    case 0:
        [self.view setValue:[UIColor redColor] forKey:@"circleColor"];
        break;
    case 1:
        [self.view setValue:[UIColor greenColor] forKey:@"circleColor"];
        break;
    case 2:
        [self.view setValue:[UIColor blueColor] forKey:@"circleColor"];
        break;
    default:
        [self.view setValue:[UIColor blackColor] forKey:@"circleColor"];
        break;
    }
}

- (void)loadView
{
    [super loadView];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    BNRHypnosisView *backgroundView = [[BNRHypnosisView alloc] initWithFrame:frame];
    
    CGRect textFieldRect = CGRectMake(40, -30, 240, 30);
    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldRect];
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"Hypnotize me!";
    textField.returnKeyType = UIReturnKeyDone;
    
    textField.delegate = self;
    
    [backgroundView addSubview:textField];
    
    self.view = backgroundView;
    self.textField = textField;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.tabBarItem.title = @"Hypnotize";
        
        UIImage *i = [UIImage imageNamed:@"Hypno.png"];
        
        self.tabBarItem.image = i;        
        
    }
    
    return self;
}

@end
