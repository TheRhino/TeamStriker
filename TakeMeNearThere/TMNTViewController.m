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
#import "TMNTFlickrPlace.h"
#import "BusinessViewController.h"


@interface TMNTViewController ()<UITableViewDelegate, UITableViewDataSource,MKMapViewDelegate>
{
    TMNTAPIProcessor *yelpProcess;
    __weak IBOutlet MKMapView *myMapView;
    NSMutableArray *yelpData;
    TMNTLocation *mobileMakersLocation;
    __weak IBOutlet UITableView *flickrTableView;
    NSMutableArray *flickrData;
}
@end

@implementation TMNTViewController

@synthesize returnedArray;
@synthesize myManagedObjectContext;
@synthesize flickrReturnedArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    mobileMakersLocation = [[TMNTLocation alloc] init];
    
    yelpProcess = [[TMNTAPIProcessor alloc]initWithYelpSearch:@"restaurants" andLocation:mobileMakersLocation];
    
    TMNTLocation* newLocation = [[TMNTLocation alloc] initWithCurrentLocationAndUpdates];
    
    yelpProcess.delegate = self;
    
    [yelpProcess getYelpJSON];
    
}


- (void)grabArrayYelp:(NSArray *)data
{
    yelpData = [self createPlacesArray:data];
    [self addPinsToMap];
}

- (void)grabArrayFlickr:(NSArray *)data
{
    flickrData=[self createFlickrPlacesArray:data];
    [flickrTableView reloadData];
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
        place.neighborhood=[[[placeDictionary valueForKey:@"neighborhoods"]objectAtIndex:0]valueForKey:@"name"];
        place.location = placeLocation;
        [returnedArray addObject:place];
    }
    return returnedArray;
}

- (NSMutableArray *)createFlickrPlacesArray:(NSArray*)flickrPlacesData
{
    flickrReturnedArray =[[NSMutableArray alloc]init];
    for (NSDictionary *placeDictionary in flickrPlacesData)
    {
        float placeLatitude = [[placeDictionary valueForKey:@"latitude"] floatValue];
        float placeLongitude = [[placeDictionary valueForKey:@"longitude"] floatValue];
        NSString *urlStringFlickr=[placeDictionary valueForKey:@"url_m"];
        TMNTLocation *placeLocation = [[TMNTLocation alloc] initWithLatitude:placeLatitude andLongitude:placeLongitude];
        
        
        TMNTFlickrPlace *flickrPlace = [[TMNTFlickrPlace alloc] init];
        flickrPlace.name = [placeDictionary valueForKey:@"name"];
        flickrPlace.location = placeLocation;
        flickrPlace.urlString=urlStringFlickr;
        [flickrReturnedArray addObject:flickrPlace];
    }
    return flickrReturnedArray;
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
        NSString *neighborhood=[[returnedArray objectAtIndex:i]neighborhood];
        
        //coordinate make
        CLLocationCoordinate2D placeCoordinate;
        placeCoordinate.longitude = locationOfPlace.coordinate.longitude;
        placeCoordinate.latitude = locationOfPlace.coordinate.latitude;
        
        //annotation make
        TMNTAnnotation *myAnnotation = [[TMNTAnnotation alloc] initWithPosition:&placeCoordinate];
        myAnnotation.title = nameOfPlace;
        myAnnotation.subtitle=neighborhood;
        myAnnotation.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //add to map
        [myMapView addAnnotation:myAnnotation];
    }
}

-(MKPinAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    MKPinAnnotationView*pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"myMap"];
    if(pinView ==nil)
    {
        pinView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myMap"];
        
    }
    pinView.pinColor = MKPinAnnotationColorGreen;
    
    [detailButton addTarget:self action:@selector(prepareForSegue:sender:) forControlEvents:(UIControlEventTouchDown)];
    pinView.canShowCallout =YES;
    pinView.rightCalloutAccessoryView = detailButton;
    return pinView;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"It Works!");
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"annotationToNextViewController" sender:self];
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    TMNTAppDelegate *appDelegate = (TMNTAppDelegate*) [[UIApplication sharedApplication] delegate];
    myManagedObjectContext = appDelegate.managedObjectContext;
    NSNumber *latitude=[NSNumber numberWithFloat:[view.annotation coordinate].latitude];
    NSNumber *longitude=[NSNumber numberWithFloat:[view.annotation coordinate].longitude];
    TMNTLocation *clickedLocation = [[TMNTLocation alloc]initWithLatitude:[latitude floatValue] andLongitude:[longitude floatValue]];
    
    [self createYelpClick:[view.annotation title]
             withLatitude:latitude
             andLongitude:longitude];
    TMNTAPIProcessor *flickrAPIProcessor=[[TMNTAPIProcessor alloc]initWithFlickrSearch:@"bathrooms" andLocation:clickedLocation];
    flickrAPIProcessor.delegate=self;
    [flickrAPIProcessor getFlickrJSON];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(flickrData == nil)
    {
        return 0;
    }
    else
    {
        return flickrData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*customCell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifierFlickr"];
    if (customCell == nil)
    {
        customCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellIdentifierFlickr"];
    }
    TMNTFlickrPlace *newPlace =[flickrData objectAtIndex:[indexPath row]];
    
    UIImage *flickrImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:newPlace.urlString]]];
    UIView *viewThatsAnImage=[customCell viewWithTag:101];
    UIImageView *flickrImageView=(UIImageView*) viewThatsAnImage;
    flickrImageView.image=flickrImage;
    
    return customCell;
    
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
    if (![self.myManagedObjectContext save:&error])
    {
        NSLog(@"Failed because:%@",[error userInfo]);
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
