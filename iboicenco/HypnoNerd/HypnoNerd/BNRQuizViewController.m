//
//  BNRQuizViewController.m
//  Quiz
//
//  Created by iboicenco on 10/8/14.
//  Copyright (c) 2014 iboicenco. All rights reserved.
//

#import "BNRQuizViewController.h"

@interface BNRQuizViewController ()
@property (nonatomic) int currentQuestionIndex;

@property (copy, nonatomic) NSArray *questions;
@property (copy, nonatomic) NSArray *answers;

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;


@end

@implementation BNRQuizViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.showQuestion.layer.cornerRadius = 6;
    self.showAnswer.layer.cornerRadius = 6;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil
                        bundle:(NSBundle *)nibBundleOrNil
{
    // Call the init method implemented by the superclass
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Create two arrays filled with questions and answers
        // and make the pointers point to them
        self.questions = @[@"Approximately how many birthdays does the average Japanese woman have?",
                           @"Why it is impossible to send a telegram to Washington today?",
                           @"How can you lift an elephant with one hand?",
                           @"How can you drop a raw egg onto a concrete floor without cracking it?"];
        
        self.answers = @[@"Just one. All the others are anniversaries.",
                         @"Because he is dead.",
                         @"It is not a problem, since you will never find an elephant with one hand.",
                         @"Concrete floors are very hard to crack!"];
        
        self.tabBarItem.title = @"Quiz";
        UIImage *quizImage = [UIImage imageNamed:@"Quiz.png"];
        self.tabBarItem.image = quizImage;
    }
    
    // Return the address of the new object
    return self;
}

- (IBAction)showQuestion:(id)sender {
    // Step to the next question
    self.currentQuestionIndex ++;
    // Am I past the question
    if (self.currentQuestionIndex == [self.questions count]) {
        // Go back to the first question
        self.currentQuestionIndex = 0;
    }
    
    // Get the string at that index in the questions array
    NSString *question = self.questions[self.currentQuestionIndex];
    
    // Display the string in the question label
    self.questionLabel.text = question;
    
    // Reset the answer label
    self.answerLabel.text = @"???";
}

- (IBAction)showAnswer:(id)sender {
    // What is the answer to the current question?
    NSString *answer = self.answers[self.currentQuestionIndex];
    
    // Display it in the answer label
    self.answerLabel.text = answer;
}


@end
