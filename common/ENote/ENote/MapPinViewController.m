//
//  MapPinViewController.m
//  ENote
//
//  Created by Iurii Boicenco on 12/16/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "MapPinViewController.h"

@interface MapPinViewController ()

@end

@implementation MapPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Map Kit";
    self.mapView.delegate = self;
    
    CLLocationCoordinate2D centerPoint = {47.024734, 28.820791};
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(3.5, 3.5);
    MKCoordinateRegion coordinateRegion = MKCoordinateRegionMake(centerPoint, coordinateSpan);
    
    [self.mapView setRegion:coordinateRegion];
    [self.mapView regionThatFits:coordinateRegion];
    

    MyPin *annotation1 = [[MyPin alloc]initWithTitle:@"Endava" subtitle:@"Endava tower" coordinate:CLLocationCoordinate2DMake(47.024734, 28.820791)];
    [self.mapView addAnnotation:annotation1];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    
    
    [self.locationManager startUpdatingLocation];

}

- (NSString *)deviceLocation {
    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
    return theLocation;
}


//- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    static NSString *AnnotationViewID = @"annotationViewID";
//    
//    MKAnnotationView *annotationView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
//    
//    if (annotationView == nil)
//    {
//        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//    }
//    
//    //annotationView.image = [UIImage imageNamed:@"location"];
//    
//    annotationView.annotation = annotation;
//    return annotationView;
//}

@end
