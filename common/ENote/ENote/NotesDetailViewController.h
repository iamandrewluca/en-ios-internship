//
//  NotesDetailViewController.h
//  ENote
//
//  Created by iboicenco on 11/13/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "NotesStore.h"


@interface NotesDetailViewController : UIViewController

@property (nonatomic) Note *note;
@property (nonatomic) NotesStore *store;

@property (nonatomic, strong) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@end
 