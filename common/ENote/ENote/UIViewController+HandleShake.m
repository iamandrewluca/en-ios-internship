//
//  UIViewController+HandleShake.m
//  ENote
//
//  Created by Andrei Luca on 12/15/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "UIViewController+HandleShake.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation UIViewController (HandleShake)

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Credits go to:" message:@"Iurii Boicenco\nLuca Andrei\nAlex Maimescu\nNicolae Ghimbovschi" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okay = [UIAlertAction actionWithTitle:@"👏" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            SystemSoundID sound;
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"aplause" ofType:@"wav"];
            NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
            
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &sound);
            AudioServicesPlaySystemSound(sound);
        }];
        
        [alert addAction:okay];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
