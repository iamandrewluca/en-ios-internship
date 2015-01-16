//
//  HPMapOptionsViewController.h
//  Pigeon
//
//  Created by James Bucanek on 10/29/13.
//  Copyright (c) 2013 Apress. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapPinViewController.h"

@interface MapOptionsViewController : UIViewController

@property (assign,nonatomic) MKMapView *mapView;
@property (weak,nonatomic) IBOutlet UISegmentedControl *mapStyleControl;
@property (weak,nonatomic) IBOutlet UISegmentedControl *headingControl;

- (IBAction)changeMapStyle:(id)sender;
- (IBAction)changeHeading:(id)sender;
- (IBAction)done;

@end
