//
//  AppDelegate.h
//  ENote
//
//  Created by Andrei Luca on 11/10/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"

@class NotesCollectionViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) UINavigationController *appNav;
@property (nonatomic) MMDrawerController *drawerCtrl;

@end

