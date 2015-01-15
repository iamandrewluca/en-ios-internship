//
//  NoteImagePreviewController.m
//  ENote
//
//  Created by Andrei Luca on 12/24/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NoteImagePreviewController.h"
#import "ImagesStore.h"

@interface NoteImagePreviewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic) UIImage *currentImage;
@property (nonatomic) UIImage *leftImage;
@property (nonatomic) UIImage *rightImage;
@property (nonatomic) NSUInteger position;

@end

@implementation NoteImagePreviewController

@synthesize position = position;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _imagePreview.image = _currentImage;
    [_scrollView setMinimumZoomScale:1.0f];
    [_scrollView setMaximumZoomScale:1.0f];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomToOriginal:)];
    tap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tap];
    
    _closeButton.layer.cornerRadius = 10.0f;
}

- (void)setImageID:(NSString *)imageID
{
    _imageID = imageID;
    _currentImage = [[ImagesStore sharedStore] imageForNote:_note withImageID:_imageID];
    position = [_note.imagesIDs indexOfObject:imageID];
}

- (void)swiped:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        if ([[_note.imagesIDs lastObject] isEqualToString:_imageID]) {
            self.imageID = [_note.imagesIDs firstObject];
        } else {
            self.imageID = [_note.imagesIDs objectAtIndex:position + 1];
        }
        _imagePreview.image = _currentImage;
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        if ([[_note.imagesIDs firstObject] isEqualToString:_imageID]) {
            self.imageID = [_note.imagesIDs lastObject];
        } else {
            self.imageID = [_note.imagesIDs objectAtIndex:position - 1];
        }
        _imagePreview.image = _currentImage;
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionDown) {
        [self closeButton:_closeButton];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
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
