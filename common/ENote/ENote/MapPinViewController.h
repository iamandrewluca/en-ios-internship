//
//  MapPinViewController.h
//  ENote
//
//  Created by Iurii Boicenco on 12/16/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyPin.h"
#import <CoreLocation/CoreLocation.h>

@interface MapPinViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic,retain) CLLocationManager *locationManager;


@end
