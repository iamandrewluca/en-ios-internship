//
//  Notebook.h
//  ENote
//
//  Created by Andrei Luca on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NotesStore;

@interface Notebook : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *notebookFolder;
@property (nonatomic, copy, readonly) NSDate *dateCreated;
@property (nonatomic) NotesStore *notes;

- (instancetype)initWithName:(NSString *)name;

@end
