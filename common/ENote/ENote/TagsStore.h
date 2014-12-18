//
//  TagsStore.h
//  ENote
//
//  Created by Andrei Luca on 11/28/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tag;

@interface TagsStore : NSObject

- (Tag *)createTagWithName:(NSString *)name;
- (void)removeTag:(Tag *)tag;
- (Tag *)getTagWithID:(NSString *)ID;
- (Tag *)getTagWithName:(NSString *)name;
- (NSMutableArray *)tagsWhichContainText:(NSString *)text;
- (NSUInteger)countAvailableSections;
- (NSUInteger)countInSection:(NSUInteger)section;
- (NSArray *)tagsForSection:(NSUInteger)section;
- (NSString *)characterForSection:(NSInteger)section;

+ (instancetype)sharedStore;

@end
