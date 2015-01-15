//
//  MyPin.m
//  ENote
//
//  Created by Iurii Boicenco on 12/16/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "MyPin.h"

@implementation MyPin

-(id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle coordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        self.title = title;
        self.subtitle = subtitle;
        self.coordinate = coordinate;
    }
    return self;
}

@end