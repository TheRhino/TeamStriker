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
    // CLLocationManager *locationManager;
}
@synthesize coordinate;

//make our own version of cllocation, that currently is hard coded to MM
- (TMNTLocation *)init
{
    self = [super init];
    
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

- (TMNTLocation *)initWithCurrentLocationAndUpdates
{
    self = [super init];
    if (self)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        [self startUpdatingLocations];
    }
    
    return self;
}

- (BOOL) locationKnown
{
    return NO;
}

- (void)startUpdatingLocations
{
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* newestLocation = [locations objectAtIndex:0];
    NSLog(@"Hello world");
    if ( abs([newestLocation.timestamp timeIntervalSinceDate:[NSDate date]]) < 120)
    {
        self.coordinate = newestLocation.coordinate;
        NSLog(@"THIS IS THE LONGITUDE DUDE MOOD: %f", self.coordinate.longitude);
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
} 
@end

