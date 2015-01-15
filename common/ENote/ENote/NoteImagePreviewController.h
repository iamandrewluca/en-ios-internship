//
//  NoteImagePreviewController.h
//  ENote
//
//  Created by Andrei Luca on 12/24/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface NoteImagePreviewController : UIViewController

@property (nonatomic) Note *note;
@property (nonatomic, copy) NSString *imageID;

@end
