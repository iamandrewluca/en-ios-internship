//
//  NotebooksStore.h
//  ENote
//
//  Created by Andrei Luca on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Notebook;

@interface NotebooksStore : NSObject

@property (nonatomic, readonly) NSArray *allNotebooks;

+ (instancetype)sharedStore;
- (Notebook *)createNotebook;
- (Notebook *)createNotebookWithName:(NSString *)name;
- (Notebook *)createNotebookWithName:(NSString *)name atDate:(NSDate *)date andFolder:(NSString *)folder;
- (void)removeNotebook:(Notebook *)notebook;
- (void)renameNotebook:(Notebook *)notebook withName:(NSString *)name;
@end
