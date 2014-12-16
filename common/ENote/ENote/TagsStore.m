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

@property (nonatomic, copy) NSMutableDictionary *tagSections;

@end

@implementation TagsStore

- (NSUInteger)countAvailableSections
{
    NSUInteger count = 0;
    
    for (NSString *key in _tagSections) {
        if ([_tagSections[key] count] > 0) {
            count++;
        }
    }
    
    return count;
}

- (NSUInteger)countInSection:(NSUInteger)section
{
    NSUInteger iterator = 0;
    
    for (NSString *key in _tagSections) {
        if ([_tagSections[key] count]) {
            if (iterator == section) {
                return [_tagSections[key] count];
            } else {
                iterator++;
            }
        }
    }
    
    return 0;
}

- (NSString *)characterForSection:(NSInteger)section
{
    NSUInteger iterator = 0;
    
    for (NSString *key in _tagSections) {
        if ([_tagSections[key] count]) {
            if (iterator == section) {
                return key;
            } else {
                iterator++;
            }
        }
    }
    
    return nil;
}

- (NSString *)nameFirstChar:(NSString *)name
{
    NSString *firstCharacter = [[name substringToIndex:1] uppercaseString];
    
    char firstChar = [firstCharacter UTF8String][0];
    
    if (((firstChar >= 65) && (firstChar <= 90)) ||
        ((firstChar >= 48) && (firstChar <= 57))) {
        
        return firstCharacter;
    } else {
        return @"#";
    }
    
    return nil;
}

- (Tag *)createTagWithName:(NSString *)name
{
    
    NSString *firstChar = [self nameFirstChar:name];
    
    for (Tag *tag in _tagSections[firstChar]) {
        if ([tag.name isEqualToString:name]) {
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
    NSString *firstChar = [self nameFirstChar:name];
    
    for (Tag *tag in _tagSections[firstChar]) {
        if ([tag.name isEqualToString:name]) {
            return tag;
        }
    }
    
    return  nil;
}

+ (instancetype)sharedStore
{
    
    static TagsStore *sharedStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        
        _tagSections = [[NSMutableDictionary alloc] initWithCapacity:37];
        
        _tagSections[@"#"] = [NSMutableArray new];
        
        NSString *firstChar;
        
        for (char c = 'A'; c <= 'Z'; c++) {
            firstChar = [NSString stringWithFormat:@"%c", c];
            _tagSections[firstChar] = [NSMutableArray new];
        }
        
        for (char c = '0'; c <= '9'; c++) {
            firstChar = [NSString stringWithFormat:@"%c", c];
            _tagSections[firstChar] = [NSMutableArray new];
        }
        
        [self loadTags];
    }
    
    return self;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[TagsStore sharedStore]" userInfo:nil];
}

- (void)addTag:(Tag *)tag
{
    NSString *firstChar = [self nameFirstChar:tag.name];
    [_tagSections[firstChar] insertObject:tag atIndex:0];
    [self saveTags];
}

- (void)removeTag:(Tag *)tag
{
    NSString *firstChar = [self nameFirstChar:tag.name];
    [_tagSections[firstChar] removeObject:tag];
    [self saveTags];
}

- (Tag *)getTagWithID:(NSString *)ID
{
    for (NSString *key in _tagSections) {
        for (Tag *tag in _tagSections[key]) {
            if ([ID isEqualToString:tag.ID]) {
                return tag;
            }
        }
    }
    
    return nil;
}

- (NSArray *)getTagsWithIDs:(NSArray *)IDs
{
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    
    for (NSString *tagID in IDs) {
        [tags addObject:[self getTagWithID:tagID]];
    }
    
    return tags;
}

- (void)addTagFromDictionary:(NSDictionary *)dictionary
{
    Tag *tag = [[Tag alloc] initWithDictionary:dictionary];
    
    NSString *firstChar = [self nameFirstChar:tag.name];
    
    [_tagSections[firstChar] addObject:tag];
}

- (NSArray *)tagsForSection:(NSUInteger)section
{
    NSUInteger iterator = 0;
    
    for (NSString *key in _tagSections) {
        if ([_tagSections[key] count]) {
            if (iterator == section) {
                return _tagSections[key];
            } else {
                iterator++;
            }
        }
    }
    
    return  nil;
}

- (void)saveTags
{
    NSMutableDictionary *tags = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in _tagSections) {
        tags[key] = [NSMutableArray new];
        for (Tag *tag in _tagSections[key]) {
            [tags[key] addObject:[tag dictionaryRepresentation]];
        }
    }
    
    NSData *tagsData = [NSJSONSerialization dataWithJSONObject:tags options:0 error:nil];
    
    NSString *tagsPath = [NSString stringWithFormat:@"%@/%@", [[ENoteCommons shared] documentDirectory], @"tags.json"];
    
    [[NSFileManager defaultManager] createFileAtPath:tagsPath contents:tagsData attributes:nil];
    
}

- (void)loadTags {
    
    NSString *tagsPath = [NSString stringWithFormat:@"%@/%@", [[ENoteCommons shared] documentDirectory], @"tags.json"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:tagsPath]) {
        
        NSData *tagsData = [[NSFileManager defaultManager] contentsAtPath:tagsPath];
        NSDictionary *tagsDictionary = [NSJSONSerialization JSONObjectWithData:tagsData options:0 error:nil];
        
        for (NSString *key in tagsDictionary) {
            for (NSDictionary *tagDictionary in tagsDictionary[key]) {
                [self addTagFromDictionary:tagDictionary];
            }
        }
    }
}

- (NSMutableArray *)tagsWhichContainText:(NSString *)text
{
    NSMutableArray *foundTags = [NSMutableArray new];
    
    for (NSString *key in _tagSections) {
        for (Tag *tag in _tagSections[key]) {
            if ([tag.name containsString:text]) {
                [foundTags addObject:tag];
            }
        }
    }
    
    return foundTags;
}

@end
