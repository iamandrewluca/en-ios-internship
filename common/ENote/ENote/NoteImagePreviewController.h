//
//  NoteImagePreviewController.h
//  ENote
//
//  Created by Andrei Luca on 12/24/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteImagePreviewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) UIImage *image;
@end
