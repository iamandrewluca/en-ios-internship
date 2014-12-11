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

- (BOOL)addTagID:(NSString *)ID {
    
    if ([_privateTagsIDs indexOfObject:ID] == NSNotFound) {
        [_privateTagsIDs insertObject:ID atIndex:0];
        return YES;
    }

    return NO;
}

- (void)removeTagID:(NSString *)ID {
    [_privateTagsIDs removeObject:ID];
}

- (BOOL)hasTagID:(NSString *)ID
{
    return [_privateTagsIDs indexOfObject:ID] != NSNotFound;
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
        
        _imageName = [NSString new];
        _thumbImage = [NSString new];
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        _text = dictionary[@"text"];
        _privateTagsIDs = dictionary[@"tagsIDs"];
        _notebookID = dictionary[@"notebookID"];
        _imageName = dictionary[@"imageName"];
        _thumbImage = dictionary[@"thumbImage"];
    }
    
    return self;
}

- (NSMutableDictionary *)dictionaryRepresentation {
    
    NSMutableDictionary *dictionaryRepresentation = [super dictionaryRepresentation];
    [dictionaryRepresentation setValue:_text forKey:@"text"];
    [dictionaryRepresentation setValue:_privateTagsIDs forKey:@"tagsIDs"];
    [dictionaryRepresentation setValue:_notebookID forKey:@"notebookID"];
    [dictionaryRepresentation setValue:_imageName forKey:@"imageName"];
    [dictionaryRepresentation setValue:_thumbImage forKey:@"thumbImage"];
    
    return dictionaryRepresentation;
}

@end
