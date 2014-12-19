//
//  MyPin.h
//  ENote
//
//  Created by Iurii Boicenco on 12/16/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MyPin : MKPointAnnotation

-(id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle
        coordinate:(CLLocationCoordinate2D)coordinate;

@end
