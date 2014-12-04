//
//  ENoteCommons.m
//  ENote
//
//  Created by Andrei Luca on 11/18/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "ENoteCommons.h"

@implementation ENoteCommons

+ (instancetype)shared {
    
    static ENoteCommons *sharedCommons = nil;
    
    if (!sharedCommons) {
        sharedCommons = [[self alloc] initPrivate];
    }
    
    return  sharedCommons;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[NotebooksStore sharedStore]" userInfo:nil];
}

- (instancetype)initPrivate {
    
    self = [super init];
    
    if (self) {
        
        NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _documentDirectory = [documentDirectories firstObject];
        
        _indexFile = @"index.json";
        
    }
    
    return self;
}

- (NSArray *)getValidItemsPathsInFolder:(NSString *)folder {
    
    NSArray *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folder error:nil];
    NSMutableArray *allPaths = [NSMutableArray arrayWithArray:paths];
    
    NSString *pattern = @"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    for (int i = 0; i < allPaths.count; i++) {
        
        NSString *path = allPaths[i];
        NSUInteger count = [regex numberOfMatchesInString:path options:0 range:NSMakeRange(0, path.length)];
        
        if (count == 0) {
            [allPaths removeObject:path];
        }
    }
    
    return allPaths;
}


@end
