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
#import "TMNTAppDelegate.h"
#import "YelpClick.h"


@interface TMNTViewController ()<MKMapViewDelegate>
{
    TMNTAPIProcessor *yelpProcess;
    __weak IBOutlet MKMapView *myMapView;
    NSMutableArray *yelpData;
    TMNTLocation *mobileMakersLocation;
}
@end

@implementation TMNTViewController

@synthesize returnedArray;
@synthesize myManagedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mobileMakersLocation = [[TMNTLocation alloc] init];

    yelpProcess = [[TMNTAPIProcessor alloc]initWithYelpSearch:@"food" andLocation:mobileMakersLocation];
    
    TMNTLocation* newLocation = [[TMNTLocation alloc] initWithCurrentLocationAndUpdates];
    
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
        TMNTLocation *placeLocation = [[TMNTLocation alloc] initWithLatitude:placeLatitude andLongitude:placeLongitude];
        
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

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    TMNTAppDelegate *appDelegate = (TMNTAppDelegate*) [[UIApplication sharedApplication] delegate];
    myManagedObjectContext = appDelegate.managedObjectContext;
    NSNumber *latitude=[NSNumber numberWithFloat:[view.annotation coordinate].latitude];
    NSNumber *longitude=[NSNumber numberWithFloat:[view.annotation coordinate].longitude];
    
    [self createYelpClick:[view.annotation title]
             withLatitude:latitude
             andLongitude:longitude];
    
}

-(void)createYelpClick:(NSString*)name withLatitude:(NSNumber*)latitude andLongitude:(NSNumber*)longitude
{
    YelpClick *yelpClick = [NSEntityDescription insertNewObjectForEntityForName:@"YelpClick" inManagedObjectContext:myManagedObjectContext];
    yelpClick.name = name;
    yelpClick.latitude = latitude;
    yelpClick.longitude = longitude;
    NSError *error;
    [self saveWithError:error];
    
}

-(void)saveWithError:(NSError*)error
{
    if (![self.myManagedObjectContext save:&error]) {
        NSLog(@"Failed because:%@",[error userInfo]);
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
