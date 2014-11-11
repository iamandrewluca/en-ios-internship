//
//  Notebook.m
//  ENote
//
//  Created by Andrei Luca on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "Notebook.h"

@implementation Notebook

- (instancetype)init {
    return [self initWithName:@"Sample Notebook"];
}

- (instancetype)initWithName:(NSString *)name {
    
    self = [super init];
    
    if (self) {
        
        _name = name;
        _folderName = [[NSUUID UUID] UUIDString];
        _dateCreated = [NSDate date];
        _notes = [[NSMutableArray alloc] init];
        
    }
    
    return self;
}

- (NSString *)description {
    return _name;
}

@end
