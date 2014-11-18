//  Note.m
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "Note.h"

@interface Note ()

@property (nonatomic, strong, readwrite) NSURL *imageURL;
@property (nonatomic, strong, readwrite) UIImage *noteImage;

@end

@implementation Note

- (NSDictionary *)dictionaryRepresentation {
    
    return @{
             @"text": _text,
             @"notebookFolder": _noteFolder,
             @"dateCreated": [NSString stringWithFormat:@"%.0f", [_dateCreated timeIntervalSince1970]]
             };
    
}

- (instancetype)init {
    return [self initWithText:@"Just a Note"];
}

- (instancetype)initWithText:(NSString *)text {
    return [self initWithText:text atDate:[NSDate date] andFolder:[[NSUUID UUID] UUIDString]];
}

- (instancetype)initWithText:(NSString *)text atDate:(NSDate *)date andFolder:(NSString *)folder {
    
    self = [super init];
    
    if (self) {
        
        _text = text;
        _noteFolder = folder;
        
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@", [[ENoteCommons shared] documentDirectory], _notebookFolder]
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];

        _dateCreated = date;
        
    }
    
    return self;
}

@end
