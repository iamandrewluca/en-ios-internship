//
//  Notebook.m
//  ENote
//
//  Created by Andrei Luca on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "Notebook.h"

@implementation Notebook

- (instancetype)initWithName:(NSString *)name {
    
    self = [super initWithName:name];
    
    if (self) {
        _notesIDs = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        _notesIDs = dictionary[@"notesIDs"];
    }
    
    return self;
}

- (NSMutableDictionary *)dictionaryRepresentation {
    
    NSMutableDictionary *dictionaryRepresentation = [super dictionaryRepresentation];
    [dictionaryRepresentation setValue:_notesIDs forKey:@"notesIDs"];
    
    return dictionaryRepresentation;
}

@end
