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
#import "TMNTAnnotation.h"
#import <CoreLocation/CoreLocation.h>


@interface TMNTViewController ()
{
    TMNTAPIProcessor *yelpProcess;
    __weak IBOutlet MKMapView *myMapView;
    NSMutableArray *yelpData;
    TMNTLocation *mobileMakersLocation;
}
@end

@implementation TMNTViewController
@synthesize returnedArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mobileMakersLocation = [[TMNTLocation alloc] init];

    yelpProcess = [[TMNTAPIProcessor alloc]initWithYelpSearch:@"food" andLocation:mobileMakersLocation];
    
    yelpProcess.delegate = self;

    [yelpProcess getYelpJSON];
}

- (void)grabArray:(NSArray *)data
{
    yelpData = [self createPlacesArray:data];
    [self addPinsToMap];
}

- (NSMutableArray *)createPlacesArray:(NSArray *)placesData
{
    returnedArray = [[NSMutableArray alloc] init];
    
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

-(void)addPinsToMap
{
    //make region our area
    MKCoordinateSpan span =
    {
        .latitudeDelta = 0.01810686f,
        .longitudeDelta = 0.01810686f
    };
    
    MKCoordinateRegion myRegion = {mobileMakersLocation.coordinate, span};
    //set region to mapview
    [myMapView setRegion:myRegion];
    
    
    for (int i = 0; i < returnedArray.count; i++)
    {
        CLLocation *locationOfPlace = [[returnedArray objectAtIndex:i] location];
        NSString *nameOfPlace = [[returnedArray objectAtIndex:i] name];
        
        //coordinate make
        CLLocationCoordinate2D placeCoordinate;
        placeCoordinate.longitude = locationOfPlace.coordinate.longitude;
        placeCoordinate.latitude = locationOfPlace.coordinate.latitude;
        
        //annotation make
        TMNTAnnotation *myAnnotation = [[TMNTAnnotation alloc] initWithPosition:&placeCoordinate];
        myAnnotation.title = nameOfPlace;
        
        //add to map
        [myMapView addAnnotation:myAnnotation];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
