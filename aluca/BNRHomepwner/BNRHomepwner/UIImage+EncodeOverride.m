//
//  UIImage+EncodeOverride.m
//  BNRHomepwner
//
//  Created by Andrei Luca on 11/4/14.
//  Copyright (c) 2014 Andrei Luca. All rights reserved.
//

#import "UIImage+EncodeOverride.h"

@implementation UIImage (EncodeOverride)

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:UIImagePNGRepresentation(self) forKey:@"image"];
    NSLog(@"Encoded");
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [UIImage imageWithData:[aDecoder decodeObjectForKey:@"image"]];
    
    NSLog(@"Decoded");
    
    return self;
}

@end
