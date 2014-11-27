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

- (instancetype)initWithName:(NSString *)name {
    
    self = [super initWithName:name];
    
    if (self) {
        _text = [[NSString alloc] init];
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        _text = dictionary[@"text"];
    }
    
    return self;
}

@end
