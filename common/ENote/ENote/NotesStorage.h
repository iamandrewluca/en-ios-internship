//
//  Note.h
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Note;

@interface NotesStorage : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong, readonly) NSArray *notes;

- (void)addNote:(Note *)note;
- (BOOL)removeNote:(Note *)note;

@end
