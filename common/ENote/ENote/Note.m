//  Note.m
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "Note.h"
#import <UIKit/UIKit.h>

@interface Note ()

@property (nonatomic) NSMutableArray *privateTagsIDs;

@end

@implementation Note

- (void)addTagID:(NSString *)ID {
    [_privateTagsIDs addObject:ID];
}

- (void)removeTagID:(NSString *)ID {
    [_privateTagsIDs removeObject:ID];
}

- (NSArray *)tagsIDs {
    return _privateTagsIDs;
}

- (instancetype)initWithName:(NSString *)name forNotebookID:(NSString *)ID {
    
    self = [self initWithName:name];
    
    if (self) {
        _text = [[NSString alloc] init];
        _privateTagsIDs = [[NSMutableArray alloc] init];
        _notebookID = ID;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        _text = dictionary[@"text"];
        _privateTagsIDs = dictionary[@"tagsIDs"];
    }
    
    return self;
}

- (NSMutableDictionary *)dictionaryRepresentation {
    
    NSMutableDictionary *dictionaryRepresentation = [super dictionaryRepresentation];
    [dictionaryRepresentation setValue:_text forKey:@"text"];
    [dictionaryRepresentation setValue:_privateTagsIDs forKey:@"tagsIDs"];
    
    return dictionaryRepresentation;
}

@end
