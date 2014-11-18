//
//  NotesDetailViewController.h
//  ENote
//
//  Created by iboicenco on 11/13/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NotesDetailViewController : UIViewController

@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) IBOutlet UITextView *noteTextView;

@property (weak, nonatomic) IBOutlet UIButton *decolor;
@property (weak, nonatomic) IBOutlet UIButton *outlineButton;
@property (weak, nonatomic) IBOutlet UIButton *unoutlineButton;

@property (weak, nonatomic) IBOutlet UIButton *redRoundCorner;
@property (weak, nonatomic) IBOutlet UIButton *greenRoundCorner;
@property (weak, nonatomic) IBOutlet UIButton *orangeRoundCorner;
@property (weak, nonatomic) IBOutlet UIButton *purpleRoundCorner;


@end
 