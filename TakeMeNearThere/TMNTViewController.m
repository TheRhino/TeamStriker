//
//  TMNTViewController.m
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/5/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "TMNTViewController.h"
#import "TMNTLocation.h"
#import "TMNTAPIProcessor.h"
#import "TMNTPlace.h"
#import "TMNTAnnotation.h"
#import "TMNTAppDelegate.h"
#import "YelpClick.h"
#import "TMNTFlickrPlace.h"
#import "BusinessViewController.h"
#import "TMNTCell.h"

@interface TMNTViewController ()<UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate>
{
    TMNTAPIProcessor *yelpProcess;
    TMNTLocation *mobileMakersLocation;
    
    __weak IBOutlet UITableView *flickrTableView;
    __weak IBOutlet MKMapView *myMapView;
    NSMutableArray *flickrData;
    
    
    NSString *nameOfPlace;
    
    
    NSString *clickedBusiness;
    NSString *clickedBusinessNeighborhood;
    NSString *clickedBusinessPhotoURL;
    NSString *clickedBusinessStreetAddress;
    NSString *clickedCity;
    NSString *clickedState;
    NSString *clickedZip;
    NSString *clickedPhone;
    
    NSMutableArray *yelpData;
    NSMutableDictionary *flickrPicturesDictionary;
    __weak IBOutlet UIActivityIndicatorView *annotationActivityIndicator;
    __weak IBOutlet NSLayoutConstraint *mapViewVerticalConstraint;
}
@end

@implementation TMNTViewController

@synthesize myManagedObjectContext;
@synthesize flickrReturnedArray;
@synthesize returnedArray;

#pragma mark View stuff


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    flickrPicturesDictionary = [NSMutableDictionary dictionary];
    mobileMakersLocation = [[TMNTLocation alloc] init];
    
    //make region our area
    MKCoordinateSpan span =
    {
        .latitudeDelta = 0.01410686f,
        .longitudeDelta = 0.01410686f
    };
    
    MKCoordinateRegion myRegion = {mobileMakersLocation.coordinate, span};
    //set region to mapview
    [myMapView setRegion:myRegion];
    
    yelpProcess = [[TMNTAPIProcessor alloc]initWithYelpSearch:@"restaurants" andLocation:mobileMakersLocation];
    
    yelpProcess.delegate = self;
    
    [yelpProcess getYelpJSON];
    

    CGAffineTransform rotateTable = CGAffineTransformMakeRotation(-M_PI_2);
    flickrTableView.transform = rotateTable;
    flickrTableView.backgroundColor = [UIColor blackColor];
}

- (void)grabArrayYelp:(NSArray *)data
{
    [annotationActivityIndicator startAnimating];
    yelpData = [self createPlacesArray:data];
    [self addPinsToMap];
    [annotationActivityIndicator stopAnimating];
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
        place.photoURLString=[placeDictionary valueForKey:@"photo_url"];
        place.streetAddress=[placeDictionary valueForKey:@"address1"];
        place.city=[placeDictionary valueForKey:@"city"];
        place.state=[placeDictionary valueForKey:@"state"];
        place.zip = [placeDictionary valueForKey:@"zip"];
        place.phone=[placeDictionary valueForKey:@"phone"];
        place.location = placeLocation;
        [returnedArray addObject:place];
    }
    return returnedArray;
}

-(void)addPinsToMap
{
    for (int i = 0; i < returnedArray.count; i++)
    {
        CLLocation *locationOfPlace = [[returnedArray objectAtIndex:i] location];
        nameOfPlace = [[returnedArray objectAtIndex:i] name];
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
        myAnnotation.place = [returnedArray objectAtIndex:i];
        //add to map
        [myMapView addAnnotation:myAnnotation];
        
    }
}

-(MKPinAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    } else
    {
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        MKPinAnnotationView*pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"myMap"];
        
        if(pinView ==nil)
        {
            pinView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myMap"];
        }
        
        pinView.pinColor = MKPinAnnotationColorGreen;
    
        pinView.canShowCallout =YES;
        pinView.rightCalloutAccessoryView = detailButton;
        return pinView;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"annotationToNextViewController" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BusinessViewController *businessPage=[segue destinationViewController];
    businessPage.businessName = clickedBusiness;
    businessPage.neighborhoodName = clickedBusinessNeighborhood;
    businessPage.businessURL = clickedBusinessPhotoURL;
    businessPage.businessStreetAddress = clickedBusinessStreetAddress;
    businessPage.businessCityStateZip = [NSString stringWithFormat:@"%@, %@, %@",clickedCity,clickedState,clickedZip];
    businessPage.businessphone = clickedPhone;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    TMNTAppDelegate *appDelegate = (TMNTAppDelegate*) [[UIApplication sharedApplication] delegate];
    myManagedObjectContext = appDelegate.managedObjectContext;
    
    NSNumber *latitude=[NSNumber numberWithFloat:[view.annotation coordinate].latitude];
    NSNumber *longitude=[NSNumber numberWithFloat:[view.annotation coordinate].longitude];
    TMNTLocation *clickedLocation = [[TMNTLocation alloc]initWithLatitude:[latitude floatValue] andLongitude:[longitude floatValue]];
    clickedBusiness=[view.annotation title];
    clickedBusinessNeighborhood=[view.annotation subtitle];
    
    TMNTAnnotation *myAnnotation = (TMNTAnnotation *) view.annotation;
    NSLog(@"%@", myAnnotation.place.photoURLString);
    clickedBusinessPhotoURL=myAnnotation.place.photoURLString;
    clickedBusinessStreetAddress=myAnnotation.place.streetAddress;
    clickedCity=myAnnotation.place.city;
    clickedState = myAnnotation.place.state;
    clickedZip = myAnnotation.place.zip;
    clickedPhone = myAnnotation.place.phone;
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"YelpClick" inManagedObjectContext:myManagedObjectContext];
    NSFetchRequest *fetchRequest =[[NSFetchRequest alloc] init];
    NSError *error;
    fetchRequest.entity = entityDescription;
    NSArray *pastClicks = [myManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    int count = 0;
    // REPLACE WITH PREDICATE LATER
    for (YelpClick *pastClick in pastClicks)
    {
        if ([[view.annotation title] isEqualToString:pastClick.name])
        {
            count++;
        }
    }
    
    if (pastClicks.count == 0 || count == 0)
    {
        [self createYelpClick:[view.annotation title]
                 withLatitude:latitude
                 andLongitude:longitude];
    }

    TMNTAPIProcessor *flickrAPIProcessor=[[TMNTAPIProcessor alloc]initWithFlickrSearch:@"food" andLocation:clickedLocation];
    flickrAPIProcessor.delegate=self;
    [flickrAPIProcessor getFlickrJSON];

    [self shrinkMapView];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view 
{
    [self expandMapView];

}

-(void)createYelpClick:(NSString*)name withLatitude:(NSNumber*)latitude andLongitude:(NSNumber*)longitude
{
    YelpClick *yelpClick = [NSEntityDescription insertNewObjectForEntityForName:@"YelpClick" inManagedObjectContext:myManagedObjectContext];
    yelpClick.name = name;
    yelpClick.latitude = latitude;
    yelpClick.longitude = longitude;
    yelpClick.timestamp = [NSDate date];
    yelpClick.favorite = 0;
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

#pragma mark Flickr stuff

- (void)grabArrayFlickr:(NSArray *)data
{
    if (flickrPicturesDictionary != nil)
    {
        [flickrPicturesDictionary removeAllObjects];
    }
    
    flickrData = [self createFlickrPlacesArray:data];
    [flickrTableView reloadData];
}

- (NSMutableArray *)createFlickrPlacesArray:(NSArray*)flickrPlacesData
{
    flickrReturnedArray =[[NSMutableArray alloc]init];
    for (NSDictionary *placeDictionary in flickrPlacesData)
    {
        float placeLatitude = [[placeDictionary valueForKey:@"latitude"] floatValue];
        float placeLongitude = [[placeDictionary valueForKey:@"longitude"] floatValue];
        NSString *urlStringFlickr = [placeDictionary valueForKey:@"url_m"];
        NSString *urlStringFlickrThumbnail = [placeDictionary valueForKey:@"url_t"];
        TMNTLocation *placeLocation = [[TMNTLocation alloc] initWithLatitude:placeLatitude andLongitude:placeLongitude];
        
        TMNTFlickrPlace *flickrPlace = [[TMNTFlickrPlace alloc] init];
        flickrPlace.name = [placeDictionary valueForKey:@"name"];
        flickrPlace.location = placeLocation;
        flickrPlace.urlString = urlStringFlickr;
        flickrPlace.urlStringThumbnail = urlStringFlickrThumbnail;
        [flickrReturnedArray addObject:flickrPlace];
    }
    return flickrReturnedArray;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (flickrData == nil)
    {
        return 0;
    } else
    {
        return flickrData.count;
    }
}

-(BOOL)shrinkMapView
{
    
    [MKMapView beginAnimations:nil context:nil];
    [MKMapView setAnimationDuration:.75];
//    myMapView.frame = CGRectMake(0, 0, 320, 375);
    [mapViewVerticalConstraint setConstant:-80];
    [myMapView layoutIfNeeded];
    [MKMapView commitAnimations];
    return YES;
    
}

-(void)expandMapView
{
    
    [MKMapView beginAnimations:nil context:nil];
    [MKMapView setAnimationDuration:.75];
    //    myMapView.frame = CGRectMake(0, 0, 320, 375);
    [mapViewVerticalConstraint setConstant:+80];
    [myMapView layoutIfNeeded];
    [MKMapView commitAnimations];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"cellIdentifierFlickr";
    
    TMNTCell *customCell = (TMNTCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (customCell == nil)
    {
        customCell = [[TMNTCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellIdentifierFlickr"];
    }
    
    TMNTFlickrPlace *newPlace =[flickrData objectAtIndex:[indexPath row]];
    
    UIView *viewThatsAnImage = [customCell viewWithTag:101];
    UIImageView *flickrImageView = (UIImageView*) viewThatsAnImage;
    customCell.contentView.backgroundColor = [UIColor blackColor];
    
    CGAffineTransform rotateImage = CGAffineTransformMakeRotation(M_PI_2);
    flickrImageView.transform = rotateImage;
    
    if ([flickrPicturesDictionary valueForKey:newPlace.urlStringThumbnail] == nil)
    {
        [customCell pullImageFromStringURL:[newPlace urlStringThumbnail] appendDictionary:flickrPicturesDictionary onImageView:flickrImageView];
    } else
    {
        UIImage *existingImage = [flickrPicturesDictionary valueForKey:newPlace.urlStringThumbnail];
        flickrImageView.image = existingImage;
    }
    
    return customCell;
}


@end
