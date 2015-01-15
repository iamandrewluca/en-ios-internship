//
//  Notebook.m
//  ENote
//
//  Created by Andrei Luca on 11/11/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "Notebook.h"

@interface Notebook ()

@property (nonatomic) NSMutableArray *privateNotesIDs;

@end

@implementation Notebook

- (void)addNoteID:(NSString *)ID
{
    [_privateNotesIDs addObject:ID];
}

- (void)removeNoteID:(NSString *)ID
{
    [_privateNotesIDs removeObject:ID];
}

- (NSArray *)notesIDs
{
    return _privateNotesIDs;
}

- (instancetype)initWithName:(NSString *)name
{
    self = [super initWithName:name];
    
    if (self) {
        _privateNotesIDs = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        _privateNotesIDs = dictionary[@"notesIDs"];
    }
    
    return self;
}

- (NSMutableDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionaryRepresentation = [super dictionaryRepresentation];
    [dictionaryRepresentation setValue:_privateNotesIDs forKey:@"notesIDs"];
    
    return dictionaryRepresentation;
}

@end
