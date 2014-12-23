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
@property (nonatomic) NSMutableArray *privateImagesIDs;

@end

@implementation Note

- (void)addImageID:(NSString *)ID
{
    [_privateImagesIDs insertObject:ID atIndex:0];
}

- (void)removeImageID:(NSString *)ID
{
    [_privateImagesIDs removeObject:ID];
}

- (BOOL)addTagID:(NSString *)ID
{
    
    if ([_privateTagsIDs indexOfObject:ID] == NSNotFound) {
        [_privateTagsIDs insertObject:ID atIndex:0];
        return YES;
    }
    
    return NO;
}

- (void)setLocationLongitude:(CGFloat)longitude andLatitude:(CGFloat)latitude
{
    _longitude = longitude;
    _latitude = latitude;
}

- (void)removeTagID:(NSString *)ID
{
    [_privateTagsIDs removeObject:ID];
}

- (BOOL)hasTagID:(NSString *)ID
{
    return [_privateTagsIDs indexOfObject:ID] != NSNotFound;
}

- (NSArray *)tagsIDs
{
    return _privateTagsIDs;
}

- (NSArray *)imagesIDs
{
    return _privateImagesIDs;
}

- (instancetype)initWithName:(NSString *)name forNotebookID:(NSString *)ID
{
    self = [self initWithName:name];
    
    if (self) {
        _text = [NSString new];
        _privateTagsIDs = [NSMutableArray new];
        _notebookID = ID;
        _thumbID = [NSString new];
        _privateImagesIDs = [NSMutableArray new];
        _longitude = 0.0f;
        _latitude = 0.0f;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        _text = dictionary[@"text"];
        _privateTagsIDs = dictionary[@"tagsIDs"];
        _notebookID = dictionary[@"notebookID"];
        _privateImagesIDs = dictionary[@"imagesIDs"];
        _thumbID = dictionary[@"thumbID"];
        _longitude = [dictionary[@"longitude"] doubleValue];
        _latitude = [dictionary[@"latitude"] doubleValue];
    }
    
    return self;
}

- (NSMutableDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionaryRepresentation = [super dictionaryRepresentation];
    [dictionaryRepresentation setValue:_text forKey:@"text"];
    [dictionaryRepresentation setValue:_privateTagsIDs forKey:@"tagsIDs"];
    [dictionaryRepresentation setValue:_notebookID forKey:@"notebookID"];
    [dictionaryRepresentation setValue:_thumbID forKey:@"thumbID"];
    [dictionaryRepresentation setValue:_privateImagesIDs forKey:@"imagesIDs"];
    [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%f", _longitude] forKey:@"longitude"];
    [dictionaryRepresentation setValue:[NSString stringWithFormat:@"%f", _latitude] forKey:@"latitude"];
    
    return dictionaryRepresentation;
}

@end
