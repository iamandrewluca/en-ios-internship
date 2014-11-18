//
//  AppDelegate.m
//  ENote
//
//  Created by Andrei Luca on 11/10/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "AppDelegate.h"
#import "NotebooksTableViewController.h"

#import "NotebooksStore.h"
#import "NotesStore.h"
#import "Notebook.h"
#import "Note.h"
#import "NotesCollectionViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    NotebooksTableViewController *notebooks = [[NotebooksTableViewController alloc] init];
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.backgroundColor = [UIColor whiteColor];
//    self.window.rootViewController = nav;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSLog(@"%@", NSHomeDirectory());
    
    NotebooksTableViewController *notebooks = [[NotebooksTableViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:notebooks];
    nav.navigationBar.translucent = NO;
    nav.navigationBar.opaque = YES;
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setTimeStyle:NSDateFormatterLongStyle];
    
    NSMutableArray *notebooks = [[NSMutableArray alloc] init];
    
    for (Notebook *notebook in [[NotebooksStore sharedStore] allNotebooks]) {
        
        NSMutableDictionary *notebookDictionary = [[NSMutableDictionary alloc] init];
        [notebookDictionary setValue:notebook.name forKey:@"name"];
        [notebookDictionary setValue:notebook.notebookFolder forKey:@"notebookFolder"];
        [notebookDictionary setValue:[formatter stringFromDate:notebook.dateCreated] forKey:@"dateCreated"];
        
        NSString *notebookFolder = [NSString stringWithFormat:@"%@/%@", documentDirectory, notebook.notebookFolder];
        
        [[NSFileManager defaultManager] createDirectoryAtPath:notebookFolder
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
        
        [notebooks addObject:notebookDictionary];
        
        NSMutableArray  *notes = [[NSMutableArray alloc] init];
        
        for (Note *note in [[notebook notes] allNotes]) {
            
            NSMutableDictionary *noteDictionary = [[NSMutableDictionary alloc] init];
            [noteDictionary setValue:note.text forKey:@"text"];
            [noteDictionary setValue:note.noteFolder forKey:@"noteFolder"];
            [noteDictionary setValue:[formatter stringFromDate:note.dateCreated] forKey:@"dateCreated"];
            
            NSString *noteFolder = [NSString stringWithFormat:@"%@/%@", notebookFolder, note.noteFolder];
            
            [[NSFileManager defaultManager] createDirectoryAtPath:noteFolder
                                      withIntermediateDirectories:NO
                                                       attributes:nil
                                                            error:nil];
            
            [notes addObject:noteDictionary];
        }
        
        NSMutableDictionary *notesDictionary = [[NSMutableDictionary alloc] init];
        
        [notesDictionary setValue:notes forKey:@"notes"];
        
        NSData *notesData = [NSJSONSerialization dataWithJSONObject:notesDictionary options:NSJSONWritingPrettyPrinted error:nil];
        
        [[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"%@/%@", notebookFolder, @"index.json"] contents:notesData attributes:nil];
    }
    
    NSMutableDictionary *notebooksDictionary = [[NSMutableDictionary alloc] init];
    
    [notebooksDictionary setValue:notebooks forKey:@"notebooks"];
    
    NSData *notebooksData = [NSJSONSerialization dataWithJSONObject:notebooksDictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    [[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"%@/%@", documentDirectory, @"index.json"] contents:notebooksData attributes:nil];
    
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
