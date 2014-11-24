//
//  NSObject+NSDictionaryRepresentation.m
//  ENote
//
//  Created by Andrei Luca on 11/17/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "NSObject+NSDictionaryRepresentation.h"
#import <objc/runtime.h>

@implementation NSObject (NSDictionaryRepresentation)

- (NSDictionary *)dictionaryRepresentation {
    unsigned int count = 0;
    // Get a list of all properties in the class.
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSDictionary *value = [[self valueForKey:key] dictionaryRepresentation];
        
        // Only add to the NSDictionary if it's not nil.
        if (value)
            [dictionary setObject:value forKey:key];
    }
    
    free(properties);
    
    return dictionary;
}

@end