//  Note.h
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Item.h"

@class Notebook;

@interface Note : Item

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *thumbID;
@property (nonatomic, copy) NSString *notebookID;
@property (nonatomic, copy, readonly) NSArray *tagsIDs;
@property (nonatomic, copy, readonly) NSArray *imagesIDs;
@property (nonatomic, readonly) CGFloat longitude;
@property (nonatomic, readonly) CGFloat latitude;

- (instancetype)initWithName:(NSString *)name forNotebookID:(NSString *)ID;

- (BOOL)addTagID:(NSString *)ID;
- (void)removeTagID:(NSString *)ID;
- (BOOL)hasTagID:(NSString *)ID;
- (void)addImageID:(NSString *)ID;
- (void)removeImageID:(NSString *)ID;
- (void)setLocationLongitude:(CGFloat)longitude andLatitude:(CGFloat)latitude;
- (NSString *)path;

@end