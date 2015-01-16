//
//  MapPinViewController.h
//  ENote
//
//  Created by Iurii Boicenco on 12/16/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MyPin.h"
#import "Note.h"
#import "NotesStore.h"

@interface MapPinViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

#define kPreferenceMapType        @"UDMapType"
#define kPreferenceHeading        @"UDFollowHeading"
#define kPreferenceSavedLocation  @"UDLocation"

@property (nonatomic) Note *note;
@property (nonatomic) NotesStore *notesStore;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) CLLocationManager *locationManager;

- (IBAction)dropPin:(id)sender;
- (IBAction)clearPin:(id)sender;
- (IBAction)mapOptions:(UIButton *)sender;

@end
