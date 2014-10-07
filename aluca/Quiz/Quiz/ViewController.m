//
//  ViewController.m
//  Quiz
//
//  Created by Andrei Luca on 10/7/14.
//  Copyright (c) 2014 Andrei Luca. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;

@property (nonatomic) int currentQuestionIndex;

@property (nonatomic, copy) NSArray *questions;
@property (nonatomic, copy) NSArray *answers;

@end

@implementation ViewController

- (id)init {
    
    self = [super initWithNibName:@"ViewController" bundle:nil];
    
    if (self) {
        
        self.questions = @[@"Question 1?",
                           @"Question 2?",
                           @"Question 3?"];
        
        self.answers = @[@"Answer 1!",
                         @"Answer 2!",
                         @"Answer 3!"];
        
    }
    
    return self;
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
    
    self.answerLabel.text = answer;
    
}

@end
