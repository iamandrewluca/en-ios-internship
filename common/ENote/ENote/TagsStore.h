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

@property (nonatomic, readonly) NSArray *allTags;

- (Tag *)createTagWithName:(NSString *)name;

- (void)removeTag:(Tag *)tag;

- (Tag *)getTagWithID:(NSString *)ID;

+ (instancetype)sharedStore;

@end
