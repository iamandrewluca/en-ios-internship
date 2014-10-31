//
//  ViewController.m
//  Quiz
//
//  Created by Andrei Luca on 10/7/14.
//  Copyright (c) 2014 Andrei Luca. All rights reserved.
//

#import "BNRQuizViewController.h"

@interface BNRQuizViewController ()

@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;

@property (nonatomic) int currentQuestionIndex;

@property (nonatomic, copy) NSArray *questions;
@property (nonatomic, copy) NSArray *answers;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraintQuestionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraintQuestionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraintAnswerLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraintAnswerLabel;

@end

@implementation BNRQuizViewController

- (id)init
{
    self = [super initWithNibName:@"BNRQuizViewController" bundle:nil];
    
    if (self) {
        
        self.questions = @[@"Question 1?",
                           @"Question 2?",
                           @"Question 3?"];
        
        self.answers = @[@"Answer 1!",
                         @"Answer 2!",
                         @"Answer 3!"];
        
        self.currentQuestionIndex = 0;
        
        UITabBarItem *tbi = self.tabBarItem;
        
        tbi.title = @"Quiz";
        
        UIImage *i = [UIImage imageNamed:@"quiz"];
        tbi.image = i;
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    NSString *question = self.questions[self.currentQuestionIndex];
    self.questionLabel.text = question;
    
    self.questionLabel.alpha = 0.0;
    self.answerLabel.alpha = 0.0;
}

- (void)viewDidLayoutSubviews
{
    NSLog(@"View did layout SubViews");
}

- (void)viewDidAppear:(BOOL)animated
{
    
    CGFloat labelWidth = self.questionLabel.bounds.size.width;
    
    // Set constraints to desired values
    // will take effect after calling [self.view layoutIfNeeded]
    self.leftConstraintQuestionLabel.constant = -labelWidth;
    self.rightConstraintQuestionLabel.constant = labelWidth;
    self.leftConstraintAnswerLabel.constant = -labelWidth;
    self.rightConstraintAnswerLabel.constant = labelWidth;
    
    // layout SubViews desired constraints
    // will call viewDidLayoutSubViews
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        self.questionLabel.alpha = 1.0;
        self.answerLabel.alpha = 1.0;
        
        self.leftConstraintQuestionLabel.constant = 8;
        self.rightConstraintQuestionLabel.constant = 8;
        self.leftConstraintAnswerLabel.constant = 8;
        self.rightConstraintAnswerLabel.constant = 8;

        [self.view layoutIfNeeded];
        
    }];
}

- (IBAction)showQuestion:(id)sender {
    
    self.currentQuestionIndex++;
    
    if (self.currentQuestionIndex == [self.questions count]) {
        self.currentQuestionIndex = 0;
    }
    
    NSString *question = self.questions[self.currentQuestionIndex];
    
    self.questionLabel.text = question;
    
    self.answerLabel.text = @"???";
    
}

- (IBAction)showAnswer:(id)sender {
    
    NSString *answer = self.answers[self.currentQuestionIndex];
    
    CGRect nextlabelFrame = self.answerLabel.frame;
    nextlabelFrame.origin.y += 100;
    
    UILabel *nextLabel = [[UILabel alloc] initWithFrame:nextlabelFrame];
    [nextLabel setBackgroundColor:self.answerLabel.backgroundColor];
    [nextLabel setTextAlignment:self.answerLabel.textAlignment];
    [nextLabel setText:answer];
    
    [self.view addSubview:nextLabel];    
    
    
    [UIView animateWithDuration:1.0 animations:^{
        //animation
    } completion:^(BOOL finished) {
        //completion
    }];
}

@end
