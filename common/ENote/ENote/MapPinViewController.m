//
//  MapPinViewController.m
//  ENote
//
//  Created by Iurii Boicenco on 12/16/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "MapPinViewController.h"
#import <MapKit/MapKit.h>

@interface MapPinViewController ()
@property (copy) MKMapCamera *camera;
@end

@implementation MapPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.locationManager requestAlwaysAuthorization];

    self.mapView.delegate = self;
    self.navigationItem.title = @"Map Kit";
    [self.mapView setShowsUserLocation:YES];
    [self.view addSubview:self.mapView];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager startUpdatingLocation];
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    CLLocationCoordinate2D centerPoint = {37.331686, -122.031971};
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(3.5, 3.5);
    MKCoordinateRegion coordinateRegion = MKCoordinateRegionMake(centerPoint, coordinateSpan);
    
    [self.mapView setRegion:coordinateRegion];
    [self.mapView regionThatFits:coordinateRegion];
    
//    MyPin *annotation1 = [[MyPin alloc]initWithTitle:@"Endava" subtitle:@"Endava tower" coordinate:CLLocationCoordinate2DMake(47.024734, 28.820791)];
//    [self.mapView addAnnotation:annotation1];

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    
    [self.mapView addAnnotation:point];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mapView.showsUserLocation = YES;
    }
}

@end
