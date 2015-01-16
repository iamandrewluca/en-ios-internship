//
//  MKPointAnnotation+MapPreservation.m
//  ENote
//
//  Created by Iurii Boicenco on 1/14/15.
//  Copyright (c) 2015 Endava. All rights reserved.
//

#import "MKPointAnnotation+MapPreservation.h"

#define kInfoLocationLatitude   @"lat"
#define kInfoLocationLongitude  @"long"
#define kInfoLocationTitle      @"title"

@implementation MKPointAnnotation (MapPreservation)

- (NSDictionary *)preserveState
{
    CLLocationCoordinate2D coord = self.coordinate;
    return @{ kInfoLocationLatitude: @(coord.latitude),
              kInfoLocationLongitude: @(coord.longitude),
              kInfoLocationTitle: self.title };
}


- (void)restoreState:(NSDictionary *)state
{
    CLLocationCoordinate2D coord;
    coord.latitude  = [state[kInfoLocationLatitude] doubleValue];
    coord.longitude = [state[kInfoLocationLongitude] doubleValue];
    self.coordinate = coord;
    self.title = state[kInfoLocationTitle];
}

@end
