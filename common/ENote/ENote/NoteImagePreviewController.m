//
//  NoteImagePreviewController.m
//  ENote
//
//  Created by Andrei Luca on 12/24/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NoteImagePreviewController.h"

@interface NoteImagePreviewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@end

@implementation NoteImagePreviewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _imagePreview.image = _image;
    [_scrollView setMinimumZoomScale:1.0f];
    [_scrollView setMaximumZoomScale:1.0f];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeButton:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomToOriginal:)];
    tap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tap];
    
    _closeButton.layer.cornerRadius = 10.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

- (void)zoomToOriginal:(UIGestureRecognizer *)gesture
{
    // 100% zoom
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
