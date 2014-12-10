//
//  TagsStore.m
//  ENote
//
//  Created by Andrei Luca on 11/28/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "TagsStore.h"
#import "Tag.h"
#import "ENoteCommons.h"

@interface TagsStore ()

@property (nonatomic) NSMutableArray *allPrivateTags;

@end

@implementation TagsStore

- (Tag *)createTagWithName:(NSString *)name {
    
    for (Tag *tag in _allPrivateTags) {
        if ([tag.name isEqualToString:name]) {
            [_allPrivateTags removeObject:tag];
            [_allPrivateTags insertObject:tag atIndex:0];
            return tag;
        }
    }
    
    Tag *tag = [[Tag alloc] initWithName:name];
    
    [self addTag:tag];
    [self saveTags];
    return tag;
}

- (Tag *)getTagWithName:(NSString *)name
{
    for (Tag *tag in _allPrivateTags) {
        if ([tag.name isEqualToString:name]) {
            return tag;
        }
    }
    
    return  nil;
}

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
        
        _allPrivateTags = [[NSMutableArray alloc] init];
        
        [self loadTags];
    }
    
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[TagsStore sharedStore]" userInfo:nil];
}

- (void)addTag:(Tag *)tag {
    [_allPrivateTags insertObject:tag atIndex:0];
    [self saveTags];
}

- (void)removeTag:(Tag *)tag {
    [_allPrivateTags removeObject:tag];
    [self saveTags];
}

- (Tag *)getTagWithID:(NSString *)ID {
    
    for (Tag *tag in _allPrivateTags) {
        if ([ID isEqualToString:tag.ID]) {
            return tag;
        }
    }
    
    return nil;
}

- (NSArray *)getTagsWithIDs:(NSArray *)IDs {
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    for (NSString *tagID in _allPrivateTags) {
        [tags addObject:[self getTagWithID:tagID]];
    }
    
    return tags;
}

- (void)addTagFromDictionary:(NSDictionary *)dictionary {
    [_allPrivateTags addObject:[[Tag alloc] initWithDictionary:dictionary]];
}

- (NSArray *)allTags {
    return _allPrivateTags;
}

- (void)saveTags {
    
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    
    for (Tag *tag in _allPrivateTags) {
        [tags addObject:[tag dictionaryRepresentation]];
    }
    
    NSMutableDictionary *tagsDictionary = [[NSMutableDictionary alloc] init];
    [tagsDictionary setValue:tags forKey:@"tags"];
    
    NSData *tagsData = [NSJSONSerialization dataWithJSONObject:tagsDictionary options:0 error:nil];
    
    NSString *tagsPath = [NSString stringWithFormat:@"%@/%@", [[ENoteCommons shared] documentDirectory], @"tags.json"];
    
    [[NSFileManager defaultManager] createFileAtPath:tagsPath contents:tagsData attributes:nil];
    
}

- (void)loadTags {
    
    NSString *tagsPath = [NSString stringWithFormat:@"%@/%@", [[ENoteCommons shared] documentDirectory], @"tags.json"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:tagsPath]) {
        
        NSData *tagsData = [[NSFileManager defaultManager] contentsAtPath:tagsPath];
        NSDictionary *tagsDictionary = [NSJSONSerialization JSONObjectWithData:tagsData options:0 error:nil];
        
        for (NSDictionary *tagDictionary in tagsDictionary[@"tags"]) {
            [self addTagFromDictionary:tagDictionary];
        }
    }
}

- (NSArray *)tagsWhichContainText:(NSString *)text
{
    NSMutableArray *foundTags = [NSMutableArray new];
    
    for (Tag *tag in _allPrivateTags) {
        if ([tag.name containsString:text]) {
            [foundTags addObject:tag];
        }
    }
    
    return foundTags;
}

@end
