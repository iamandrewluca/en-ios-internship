//
//  TagsStore.m
//  ENote
//
//  Created by Andrei Luca on 11/28/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "TagsStore.h"
#import "Tag.h"

@implementation TagsStore

- (void)addTag:(Tag *)tag {
    [self addItem:tag];
    [self saveTags];
}

- (void)removeTag:(Tag *)tag {
    [self removeItem:tag];
    [self saveTags];
}

- (Item *)itemFromDictionary:(NSDictionary *)dictionary {
    return [[Tag alloc] initWithDictionary:dictionary];
}

- (void)saveTags {
    // separare tagsStore complet
}

@end
