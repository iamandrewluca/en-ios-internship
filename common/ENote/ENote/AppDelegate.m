//
//  AppDelegate.m
//  ENote
//
//  Created by Andrei Luca on 11/10/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "AppDelegate.h"
#import "NotebooksTableViewController.h"
#import "RearViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"

#import "MapPinViewController.h"

//#import <GoogleMaps/GoogleMaps.h>
//#define GOOGLE_MAPS_API_KEY @"AIzaSyCXv_-FAsbTIgGESqgePjkgBKuB6eYu4-4"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%@", NSHomeDirectory());
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIViewController *leftDrawer = [RearViewController new];
    UINavigationController *drawerNav = [[UINavigationController alloc] initWithRootViewController:leftDrawer];
    drawerNav.navigationBar.translucent = NO;
    drawerNav.navigationBar.barTintColor = [UIColor orangeColor];
    drawerNav.navigationBar.tintColor = [UIColor whiteColor];
    drawerNav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    UIViewController *notebooks = [NotebooksTableViewController new];
    self.appNav = [[UINavigationController alloc] initWithRootViewController:notebooks];
    self.appNav.navigationBar.translucent = NO;
    self.appNav.navigationBar.barTintColor = [UIColor orangeColor];
    self.appNav.navigationBar.tintColor = [UIColor whiteColor];
    self.appNav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    // Disable Navigation Controller Back Bezel Swipe
    if ([self.appNav respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.appNav.interactivePopGestureRecognizer.enabled = NO;
    }
    
    _drawerCtrl = [[MMDrawerController alloc] initWithCenterViewController:self.appNav
                                                                     leftDrawerViewController:drawerNav];
    
    [_drawerCtrl setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
    [_drawerCtrl setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeBezelPanningCenterView];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = _drawerCtrl;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
