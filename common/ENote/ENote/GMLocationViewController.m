//
//  GMLocationViewController.m
//  ENote
//
//  Created by Iurii Boicenco on 12/15/14.
//  Copyright (c) 2014 Endava. All rights reserved.
//

#import "GMLocationViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface GMLocationViewController () <GMSMapViewDelegate>
@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, copy) NSSet *markers;

@end

@implementation GMLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Google Maps";
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:47.024740
                                                            longitude:28.820829
                                                                 zoom:16
                                                              bearing:0
                                                         viewingAngle:0];
    
    self.mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    self.mapView.delegate = self;
    self.mapView.mapType = kGMSTypeNormal;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.settings.compassButton = YES;
    
    
    GMSMarker *endavaPin = [[GMSMarker alloc]init];
    endavaPin.position = CLLocationCoordinate2DMake(47.024740, 28.820829);
    endavaPin.title = @"Endava Tower";
    endavaPin.icon = [UIImage imageNamed:@"mapPin"];
    endavaPin.appearAnimation = kGMSMarkerAnimationNone;
    endavaPin.map = self.mapView;
    
    [self.mapView setMinZoom:10 maxZoom:18];
    [self.view addSubview:self.mapView];

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.mapView.padding = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0);
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    GMSGeocoder *geocoder = [GMSGeocoder geocoder];
    [geocoder reverseGeocodeCoordinate:marker.position
                     completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
                         GMSMarker *tapMarker = (GMSMarker *)marker;
                         
                         NSString *streetAddress = response.firstResult.thoroughfare;
                         NSString *city = response.firstResult.locality;
                         //NSString *state = response.firstResult.administrativeArea;
                         
                         tapMarker.snippet = [NSString stringWithFormat:@"%@, %@",
                                                streetAddress,
                                                city];
                                                //state];
    [self updateMarkerData:tapMarker];
    self.mapView.selectedMarker = tapMarker;
                         
    }];
    
    return NO;
}

- (void)updateMarkerData:(GMSMarker *)marker
{
    NSMutableSet *mutableMarkers = [self.markers mutableCopy];
    
    GMSMarker *tapMarker = [mutableMarkers member:marker];
    
    if(tapMarker) {
        [mutableMarkers removeObject:tapMarker];
        [mutableMarkers addObject:tapMarker];
        
        self.markers = [mutableMarkers copy];
    }
}

//-(void)setupMarkerDataa
//{
//    GMSMarker *marker1 = [[GMSMarker alloc]init];
//    GMSMarker *marker2 = [[GMSMarker alloc]init];
//    
//    self.markers = [NSSet setWithObjects:marker1, marker2, nil]; // << nil at the end, that's how sets are created
//    [self drawMarkers];
//}
//
//-(void)drawMarkers {
//    for (GMSMarker *marker in self.markers) {
//        if (marker.map == nil) {
//            marker.map = self.mapView;
//        }
//    }
//}

@end
