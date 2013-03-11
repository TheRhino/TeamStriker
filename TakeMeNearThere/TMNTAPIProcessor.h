//
//  TMNTAPIProcessor.h
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/5/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMNTLocation.h"
#import <YelpKit/YelpKit.h>
#import "TMNTDataSourceDelegate.h"


@interface TMNTAPIProcessor : NSObject

@property (strong, nonatomic) NSArray *flickrPhotosArray;
@property (strong, nonatomic) NSString *stringAPICall;
@property (strong, nonatomic) NSArray *yelpBusinessesArray;
@property (strong, nonatomic) id <TMNTDataSourceDelegate> delegate;


- (TMNTAPIProcessor*)initWithFlickrSearch:(NSString*)search andLocation:(TMNTLocation*)userLocation;

- (TMNTAPIProcessor*)initWithYelpSearch:(NSString*)search andLocation:(TMNTLocation*)userLocation;

//the getter and the setting of the json from flickr
- (void)getFlickrJSON;
- (void)setArrayOfDictsFromFlickrJSONWithResponse:(NSURLResponse*)myResponse andData:(NSData*)myData andError:(NSError*)theirError;


//the getting of the json from yelp
- (void)getYelpJSON;
- (void)setUpYelpVenuesWithData: (id)data;


@end
