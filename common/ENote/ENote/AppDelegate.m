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
    // Why search simulator sandbox?
    // Iura nu mai comenta linia asta ))
    NSLog(@"%@", NSHomeDirectory());
    
    // App iCloud Sandbox
    NSLog(@"%@", [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil]);
    
    // API Key
//    [GMSServices provideAPIKey:@"GOOGLE_MAPS_API_KEY"];
    
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
