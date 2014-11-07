//
//  AppDelegate.m
//  BNRHomepwner
//
//  Created by Andrei Luca on 10/16/14.
//  Copyright (c) 2014 Andrei Luca. All rights reserved.
//

#import "AppDelegate.h"
#import "BNRItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRImageStore.h"

NSString * const BNRNextItemValuePrefsKey = @"NextItemValue";
NSString * const BNRNextItemNamePrefsKey = @"NextItemName";

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (void)initialize
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *factorySettings = @{BNRNextItemValuePrefsKey: @75, BNRNextItemNamePrefsKey: @"Coffe Cup"};
    
    [defaults registerDefaults:factorySettings];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSLog(@"%@", NSHomeDirectory());
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    BNRItemsViewController *itemsViewController = [[BNRItemsViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:itemsViewController];
    navController.navigationBar.translucent = NO;
    
    self.window.rootViewController = navController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    
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
    
    BOOL successSavingItems = [[BNRItemStore sharedStore] saveChanges];
    BOOL succesSavingImages = [[BNRImageStore sharedStore] saveChanges];
    
    if (successSavingItems) {
        NSLog(@"Saved all of the BNRItems");
    } else {
        NSLog(@"Could not save any of the BNRItems");
    }
    
    if (succesSavingImages) {
        NSLog(@"Saved all of the BNRImageStore");
    } else {
        NSLog(@"Could not save any of the BNRImageStore");
    }
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
