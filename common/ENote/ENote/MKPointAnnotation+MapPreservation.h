//
//  MKPointAnnotation+MapPreservation.h
//  ENote
//
//  Created by Iurii Boicenco on 1/14/15.
//  Copyright (c) 2015 Endava. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKPointAnnotation (MapPreservation)

- (NSDictionary*)preserveState;
- (void)restoreState:(NSDictionary*)state;

@end
