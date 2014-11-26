//  Note.m
//  ENote
//
//  Created by Andrei Luca on 11/12/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "Note.h"
#import <UIKit/UIKit.h>

@interface Note ()

@end

@implementation Note

- (NSMutableDictionary *)dictionaryRepresentation {
    
    NSMutableDictionary *dictionaryRepresentation = [super dictionaryRepresentation];
    [dictionaryRepresentation setValue:_text forKey:@"text"];
    
    return dictionaryRepresentation;
}

- (instancetype)initWithName:(NSString *)name withText:text atDate:(NSDate *)date andFolder:(NSString *)folder {
    
    self = [super initWithName:name atDate:date andFolder:folder];
    
    if (self) {
        _text = text;
    }
    
    return self;
}

@end
