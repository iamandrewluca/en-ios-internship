//
//  NoteImagePreviewController.m
//  ENote
//
//  Created by Andrei Luca on 12/24/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NoteImagePreviewController.h"

@interface NoteImagePreviewController () <UIScrollViewDelegate>
@end

@implementation NoteImagePreviewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _imagePreview.image = _image;
    [_scrollView setMinimumZoomScale:1.0f];
    // scrool or swipe?
    [_scrollView setMaximumZoomScale:1.0f];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeButton:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imagePreview;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
