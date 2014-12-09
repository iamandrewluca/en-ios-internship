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

@interface NotesDetailViewController : UIViewController <UIActionSheetDelegate>

@property (nonatomic) Note *note;
@property (nonatomic) NotesStore *notesStore;

@end
 