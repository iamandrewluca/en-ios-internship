//
//  BNRImageStore.m
//  BNRHomepwner
//
//  Created by Andrei Luca on 10/21/14.
//  Copyright (c) 2014 Andrei Luca. All rights reserved.
//

#import "BNRImageStore.h"

@interface BNRImageStore ()

@property (nonatomic) NSMutableDictionary *dictionary;

@end

@implementation BNRImageStore

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:self.dictionary toFile:path];
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"images.archive"];
}

+ (instancetype)sharedStore
{
    static BNRImageStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[BNRImageStore sharedStore]" userInfo:nil];
    
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        NSString *path = [self itemArchivePath];
        _dictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!_dictionary) {
            _dictionary = [[NSMutableDictionary alloc] init];
        }
        
    }
    
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.dictionary[key] = image;
}

- (UIImage *)imageForKey:(NSString *)key
{
    return self.dictionary[key];
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    
    [self.dictionary removeObjectForKey:key];
}

@end
