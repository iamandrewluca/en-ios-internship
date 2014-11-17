//
//  NSObject+NSDictionaryRepresentation.h
//  ENote
//
//  Created by Andrei Luca on 11/17/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSDictionaryRepresentation)

/**
 Returns an NSDictionary containing the properties of an object that are not nil.
 */
- (NSDictionary *)dictionaryRepresentation;

@end