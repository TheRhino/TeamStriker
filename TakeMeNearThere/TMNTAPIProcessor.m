//
//  TMNTAPIProcessor.m
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/5/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import "TMNTAPIProcessor.h"
#import <YelpKit/YelpKit.h>


@implementation TMNTAPIProcessor

@synthesize stringAPICall,flickrPhotosArray,yelpBusinessesArray;


//api method call for flickr
- (TMNTAPIProcessor*)initWithFlickrSearch:(NSString*)search andLocation:(CLLocation*)location
{
    stringAPICall = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=bd02a7a94fbe1f4c40a1661af4cb7bbe&user_id=94174680%@N05&lat=%f&lon=%f&radius=.5&extras=geo%@+url_t%@+url_m&format=json&nojsoncallback=1",@"%40", location.coordinate.latitude, location.coordinate.longitude, @"%2C", @"%2C"];
    
    // Add Flickr API Keys Here:
    // fe96680b3eeef8c86fb070bd12322d23
    // bd02a7a94fbe1f4c40a1661af4cb7bbe
    
    return self;
}

//api method call for yelp
- (TMNTAPIProcessor*)initWithYelpSearch:(NSString*)search andMapView:(MKMapView *)mapView
{
//      IMPLEMENT WHEN WE HAVE OAUTH
//
//    //To calculate the search bounds...
//    //First we need to calculate the corners of the map so we get the points
//    CGPoint nePoint = CGPointMake(mapView.bounds.origin.x + mapView.bounds.size.width, mapView.bounds.origin.y);
//    CGPoint swPoint = CGPointMake((mapView.bounds.origin.x), (mapView.bounds.origin.y + mapView.bounds.size.height));
//    
//    //Then transform those point into lat,lng values
//    CLLocationCoordinate2D neCoord;
//    neCoord = [mapView convertPoint:nePoint toCoordinateFromView:mapView];
//    
//    CLLocationCoordinate2D swCoord;
//    swCoord = [mapView convertPoint:swPoint toCoordinateFromView:mapView];
//    stringAPICall = [NSString stringWithFormat:@"http://api.yelp.com/business_review_search?term=%@&bounds=%f,%f|%f,%f&limit=10&ywsid=SHvJpobPrBabhrCyJ8FMag",search, swCoord.latitude, swCoord.longitude, neCoord.latitude, neCoord.longitude];
    // Add YELP API Keys here:
    // SHvJpobPrBabhrCyJ8FMag - Dexters
    // aWCgjSUCSN9F5JAqLZ8NBw - ?
    
    return self;
}

- (TMNTAPIProcessor*)initWithYelpSearch:(NSString*)search andLocation:(CLLocation *)location
{
    stringAPICall = [NSString stringWithFormat:@"http://api.yelp.com/business_review_search?term=%@&radius=0.25&lat=%f&long=%f&limit=10&ywsid=aWCgjSUCSN9F5JAqLZ8NBw",search, location.coordinate.latitude, location.coordinate.longitude];
    return self;
    
    // Add YELP API Keys here:
    // SHvJpobPrBabhrCyJ8FMag - Dexters
    // aWCgjSUCSN9F5JAqLZ8NBw - ?
}

- (void) getFlickrJSON
{
    NSURLRequest* flickrRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:stringAPICall]];
    
    //not needed because it is the default
    //flickrRequest.HTTPMethod = @"GET";
    
    [NSURLConnection sendAsynchronousRequest:flickrRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^ void (NSURLResponse* myResponse, NSData* myData, NSError* theirError)
     {
         [self setArrayOfDictsFromFlickrJSONWithResponse:myResponse andData:myData andError:theirError];
         [self.delegate grabArrayFlickr:flickrPhotosArray];
         
     }];
    
}

- (void)setArrayOfDictsFromFlickrJSONWithResponse:(NSURLResponse*)myResponse andData:(NSData*)myData andError:(NSError*)theirError
{
    
    if (theirError)
    {
        NSLog(@"Flickr Error: %@", [theirError description]);
    }
    else
    {
        NSError *jsonError;
        NSDictionary *myJSONDictionary = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:myData
                                                                                         options:NSJSONReadingAllowFragments
                                                                                           error:&jsonError];
        
        flickrPhotosArray = [[myJSONDictionary valueForKey:@"photos"] valueForKey:@"photo"];
    }
}

- (void)getYelpJSON
{
    YKURL *yelpURL = [YKURL URLString:stringAPICall];
    [YKJSONRequest requestWithURL:yelpURL
                      finishBlock:^ void (id myData)
     {
         [self setUpYelpVenuesWithData:myData];
         [self.delegate grabArrayYelp:yelpBusinessesArray];
         
     }
                        failBlock:^ void (YKHTTPError *error)
     {
         if (error)
         {
             NSLog(@"Error using Yelp: %@", [error description]);
         }
     }];
    
}
-(void) setUpYelpVenuesWithData: (id)data
{
    NSDictionary *myYelpVenues = (NSDictionary *)data;
    yelpBusinessesArray = [myYelpVenues valueForKey:@"businesses"];
}

@end
