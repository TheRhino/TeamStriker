//
//  TMNTLocation.m
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/5/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import "TMNTLocation.h"

@interface TMNTLocation ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation TMNTLocation
{
    CLLocationManager *locationManager;
}
@synthesize coordinate, locationManager = locationManager;

//make our own version of cllocation, that currently is hard coded to MM
- (TMNTLocation *)init
{
    self = [super init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    coordinate.latitude = 41.894032;
    coordinate.longitude = -87.634742;
    return self;
}

- (TMNTLocation *)initWithLatitude:(float)latitude andLongitude:(float)longitude
{
    self = [super init];
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;
    return self;
}


@end

