//
//  TMNTPlace.h
//  TakeMeNearThere
//
//  Created by Dexter Teng on 3/7/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TMNTDataSourceDelegate.h"
#import "TMNTLocation.h"

@interface TMNTPlace : NSObject

@property (strong, nonatomic) TMNTLocation *location;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *neighborhood;
@property (strong, nonatomic) NSString *photoURLString;
@property (strong, nonatomic) NSString *ratingURL;
@property (strong, nonatomic) NSString *streetAddress;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *zip;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *distance;



@end
