//  Note.h
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@class Notebook;

@interface Note : Item

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy, readonly) NSArray *tagsIDs;
@property (nonatomic, copy, readonly) NSString *notebookID;
@property (nonatomic, copy, readonly) NSString *imageName;
@property (nonatomic, copy, readonly) NSString *thumbImage;

- (instancetype)initWithName:(NSString *)name forNotebookID:(NSString *)ID;

- (BOOL)addTagID:(NSString *)ID;
- (void)removeTagID:(NSString *)ID;
- (BOOL)hasTagID:(NSString *)ID;

@end
