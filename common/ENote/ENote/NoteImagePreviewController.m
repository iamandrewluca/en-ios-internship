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
    
    
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeButton:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomToOriginal:)];
    tap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidLayoutSubviews
{
//    CGFloat ratio = _imagePreview.bounds.size.width / _imagePreview.bounds.size.height;
//    if (ratio >= 0) {
//        _imagePreview.frame = CGRectMake(0, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height * ratio);
//    } else {
//        _imagePreview.frame = CGRectMake(0, 0, _scrollView.bounds.size.width * ratio, _scrollView.bounds.size.height);
//    }
//
//    _scrollView.contentSize = _imagePreview.bounds.size;
//    _scrollView.contentOffset = CGPointMake(0, _imagePreview.frame.origin.y);
//
//    
//    [_scrollView setMaximumZoomScale:_image.size.width / _scrollView.bounds.size.width];
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
    NSLog(@"ASD");
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
