//
//  BusinessViewController.h
//  TakeMeNearThere
//
//  Created by Nirav Amin on 3/20/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessViewController : UIViewController 

@property (strong, nonatomic) NSString *businessName;
@property (strong, nonatomic) NSString *neighborhoodName;
@property (strong, nonatomic) NSString *businessURL;
@property (strong, nonatomic) NSString *businessStreetAddress;
@property (strong, nonatomic) NSString *businessCityStateZip;
@property (strong, nonatomic) NSString *businessphone;
@property (strong, nonatomic) NSNumber *averageRating;
@property (strong, nonatomic) NSString *businessCategory;
@property (strong, nonatomic) NSString *distanceFromCurrentLocation;


@end
