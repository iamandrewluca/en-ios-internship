//
//  HPMapOptionsViewController.m
//  Pigeon
//
//  Created by James Bucanek on 10/29/13.
//  Copyright (c) 2013 Apress. All rights reserved.
//

#import "MapOptionsViewController.h"

@interface MapOptionsViewController ()

@end

@implementation MapOptionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	self.mapStyleControl.selectedSegmentIndex = self.mapView.mapType;
	self.headingControl.selectedSegmentIndex = self.mapView.userTrackingMode-1;
}

#pragma mark Actions

- (IBAction)changeMapStyle:(id)sender
{
	MKMapType mapType = self.mapStyleControl.selectedSegmentIndex;
    self.mapView.mapType = mapType;
    
    [[NSUserDefaults standardUserDefaults] setInteger:mapType
                                               forKey:kPreferenceMapType];
    
}

- (IBAction)changeHeading:(id)sender
{
    MKUserTrackingMode tracking = self.headingControl.selectedSegmentIndex+1;
    self.mapView.userTrackingMode = tracking;
    
    [[NSUserDefaults standardUserDefaults] setInteger:tracking
                                               forKey:kPreferenceHeading];
}

- (IBAction)done
{
	[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
