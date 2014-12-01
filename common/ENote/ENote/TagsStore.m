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

+ (instancetype)sharedStore {
    
    static TagsStore *sharedStore = nil;
    
    if (!sharedStore) {
        
        sharedStore = [[TagsStore alloc] initPrivate];
        
    }
    
    return sharedStore;
}

- (instancetype)initPrivate {
    
    self = [super init];
    
    if (self) {
        [self loadTags];
    }
    
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[NotebooksStore sharedStore]" userInfo:nil];
}

- (void)addTag:(Tag *)tag {
    [self addItem:tag];
    [self saveTags];
}

- (void)removeTag:(Tag *)tag {
    [self removeItem:tag];
    [self saveTags];
}

- (Tag *)getTagWithID:(NSString *)ID {
    
    NSMutableArray *allTags = [self valueForKey:@"_allPrivateItems"];
    
    for (Tag *tag in allTags) {
        if ([ID isEqualToString:tag.ID]) {
            return tag;
        }
    }
    
    return nil;
}

- (Item *)itemFromDictionary:(NSDictionary *)dictionary {
    return [[Tag alloc] initWithDictionary:dictionary];
}

- (void)saveTags {
    // save
}

- (void)loadTags {
    // load
}

@end
