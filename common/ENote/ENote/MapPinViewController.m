//
//  MapPinViewController.m
//  ENote
//
//  Created by Iurii Boicenco on 12/16/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "MapPinViewController.h"
#import <MapKit/MapKit.h>
#import "MapOptionsViewController.h"
#import "MKPointAnnotation+MapPreservation.h"

#define kArrowDisplayDistanceMin 50.0
@interface MapPinViewController () <UIAlertViewDelegate>
{
    MKPointAnnotation *savedAnnotation;
    UIImageView *arrowView;
}
-(void)hideReturnArrow;
-(void)showReturnArrowAtPoint:(CGPoint)userPoint towards:(CGPoint)returnPoint;

- (void)setAnnotation:(MKPointAnnotation*)annotation;
- (void)preserveAnnotation;
- (void)restoreAnnotation;
@end

@implementation MapPinViewController

#pragma mark - Lifecycle
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.locationManager requestAlwaysAuthorization];
    [self.mapView setShowsUserLocation:YES];
    
    self.navigationItem.title = @"EMap";
    self.mapView.delegate = self;
    self.toolbar.backgroundColor = [UIColor orangeColor];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    if (_note.longitude != -1.0f) {
        [self.locationManager startUpdatingLocation];
    }
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    CLLocationCoordinate2D centerPoint = {37.331686, -122.031971};
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(1.0, 1.0);
    MKCoordinateRegion coordinateRegion = MKCoordinateRegionMake(centerPoint, coordinateSpan);
    
    [_mapView setRegion:coordinateRegion];
    [_mapView regionThatFits:coordinateRegion];
    
    // Getting Values from User Defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _mapView.mapType = [userDefaults integerForKey:kPreferenceMapType];
    _mapView.userTrackingMode = [userDefaults integerForKey:kPreferenceHeading];
    
    [self restoreAnnotation];
    [self.view addSubview:self.mapView];
}

#pragma mark - (IBActions)
-(IBAction)dropPin:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"What's here?"
                                                    message:@"Type a label for this note location."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Remember", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.delegate = self;
    
    [alert show];
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        CLLocation *location = _mapView.userLocation.location;
        if (location == nil)
            return;
        
        NSString *name = [[alertView textFieldAtIndex:0] text];
        name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (name.length == 0) {
            name = @"Over Here!";
        }
        
        [_note setLocation:location withText:name];
        [_notesStore saveNote:_note];
        
        MKPointAnnotation *newAnnotation = [MKPointAnnotation new];
        newAnnotation.title = name;
        newAnnotation.coordinate = location.coordinate;
        [self setAnnotation:newAnnotation];
        [self preserveAnnotation];
    }
    
}

-(IBAction)clearPin:(id)sender
{
    if (savedAnnotation != nil)
    {
        [self setAnnotation:nil];
        [self preserveAnnotation];
        _note.longitude = -1.0f;
        _note.latitude = -1.0f;
    }
}

-(IBAction)mapOptions:(UIButton *)sender {
    MapOptionsViewController *mapOptionsVC = [[MapOptionsViewController alloc]init];
    [self.navigationController pushViewController:mapOptionsVC animated:YES];
    
    //[self presentViewController:mapOptionsVC animated:YES completion:^{ }];
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == self.mapView.userLocation)
        return nil;
    
    NSString *pinID = @"Save";
    MKPinAnnotationView *view = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:pinID];
    
    if (view ==nil) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinID];
        view.canShowCallout = YES;
        view.animatesDrop = YES;
        view.draggable = YES;
    }
    
    return view;
}

#pragma mark - Annotations
-(void)setAnnotation:(MKPointAnnotation *)annotation
{
    if ([savedAnnotation isEqual:annotation])
        return;
    
    if (savedAnnotation != nil)
        [_mapView removeAnnotation:savedAnnotation];
    savedAnnotation = annotation;
    
    if (annotation != nil)
    {
        [_mapView addAnnotation:annotation];
        [_mapView selectAnnotation:annotation animated:YES];
    }
}

- (void)preserveAnnotation
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (savedAnnotation != nil)
    {
        NSDictionary *annotationInfo = [savedAnnotation preserveState];
        [userDefaults setObject:annotationInfo forKey:kPreferenceSavedLocation];
    }
    else
    {
        [userDefaults removeObjectForKey:kPreferenceSavedLocation];
    }
}

- (void)restoreAnnotation
{
    if (_note.latitude != -1.0f && _note.longitude != -1.0f) {
        MKPointAnnotation *restoreAnnotation = [MKPointAnnotation new];
        NSDictionary *info = @{@"lat" : [NSNumber numberWithDouble:_note.latitude],
                               @"long" : [NSNumber numberWithDouble:_note.longitude],
                               @"title" : _note.pinText};
        [restoreAnnotation restoreState:info];
        [self setAnnotation:restoreAnnotation];
    }
}

#pragma mark - LocationsUpdate
-(void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
    if (mode == MKUserTrackingModeNone) {
        [mapView setUserTrackingMode:MKUserTrackingModeFollow];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager startUpdatingLocation];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (savedAnnotation != nil)
    {
        CLLocationCoordinate2D coord = savedAnnotation.coordinate;
        CLLocation *toLoc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        CLLocationDistance distance = [userLocation.location distanceFromLocation:toLoc];
        if (distance >= kArrowDisplayDistanceMin)
        {
            CGPoint userPoint = [mapView convertCoordinate:userLocation.coordinate toPointToView:self.mapView];
            CGPoint savePoint = [mapView convertCoordinate:coord toPointToView:self.mapView];
            [self showReturnArrowAtPoint:userPoint towards:savePoint];
            
            return;
        }
    }
    
    [self hideReturnArrow];
}

-(void)showReturnArrowAtPoint:(CGPoint)userPoint towards:(CGPoint)returnPoint
{
    if (arrowView == nil) {
        UIImage *arrowImage = [UIImage imageNamed:@"arrow"];
        arrowView = [[UIImageView alloc] initWithImage:arrowImage];
        arrowView.opaque = NO;
        arrowView.alpha = 0.6;
        [self.mapView addSubview:arrowView];
        arrowView.hidden = YES;
    }
    
    CGFloat angle = atan2f(returnPoint.x-userPoint.x,userPoint.y-returnPoint.y);
    CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
    void (^updateArrow)(void) = ^{
        arrowView.center = userPoint;
        arrowView.transform = rotation;
    };
    
    if (arrowView.hidden) {
        updateArrow();
        arrowView.hidden = NO;
    } else {
        [UIView animateWithDuration:0.5 animations:updateArrow];
    }
}

-(void)hideReturnArrow
{
    arrowView.hidden = YES;
}


#pragma mark - Authorization
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mapView.showsUserLocation = YES;
    }
}

@end
