//
//  TMNTViewController.m
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/5/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import "TMNTViewController.h"
#import "TMNTLocation.h"
#import "TMNTAPIProcessor.h"
#import "TMNTPlace.h"
#import <MapKit/MapKit.h>

@interface TMNTViewController ()
{
    TMNTAPIProcessor *yelpProcess;
    __weak IBOutlet MKMapView *myMapView;
    NSMutableArray *yelpData;
}
@end

@implementation TMNTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //test that tmntlocation works
//    TMNTLocation *userLocation = [[TMNTLocation alloc] init];
//    NSLog(@"%f",userLocation.location.longitude);
    TMNTLocation *location = [[TMNTLocation alloc] init];
//    TMNTAPIProcessor *flickrProcess = [[TMNTAPIProcessor sharedInstance]initWithFlickrSearch:@"hamburger" andLocation:location];
//    [flickrProcess getFlickrJSON];
//    NSLog(@"this is the %@", [flickrProcess flickrPhotosArray]);

    
    yelpProcess = [[TMNTAPIProcessor alloc]initWithYelpSearch:@"food" andLocation:location];
    yelpProcess.delegate = self;

    
    [yelpProcess getYelpJSON];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)grabArray:(NSArray *)data
{
    yelpData = [self createPlacesArray:data];
    NSLog(@"%@", yelpData);
}

- (NSMutableArray *)createPlacesArray:(NSArray *)placesData
{
    NSMutableArray *returnedArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *placeDictionary in placesData)
    {
        float placeLatitude = [[placeDictionary valueForKey:@"latitude"] floatValue];
        float placeLongitude = [[placeDictionary valueForKey:@"longitude"] floatValue];
        CLLocation *placeLocation = [[CLLocation alloc] initWithLatitude:placeLatitude longitude:placeLongitude];
        
        TMNTPlace *place = [[TMNTPlace alloc] init];
        place.name = [placeDictionary valueForKey:@"name"];
        place.location = placeLocation;
        [returnedArray addObject:place];
    }
    return returnedArray;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
