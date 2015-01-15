//
//  ENoteCommons.m
//  ENote
//
//  Created by Andrei Luca on 11/18/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "ENoteCommons.h"

@implementation ENoteCommons

+ (instancetype)shared
{
    static ENoteCommons *sharedCommons = nil;
    
    if (!sharedCommons) {
        sharedCommons = [[self alloc] initPrivate];
    }
    
    return  sharedCommons;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[NotebooksStore sharedStore]" userInfo:nil];
}

- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        
        NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _documentDirectory = [documentDirectories firstObject];
        
        _indexFile = @"index.json";
        
    }
    
    return self;
}

@end