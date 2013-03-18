//
//  TMNTLocation.h
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/5/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface TMNTLocation : NSObject <CLLocationManagerDelegate>

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

- (TMNTLocation*)init;

- (TMNTLocation *)initWithLatitude:(float)latitude andLongitude:(float)longitude;

- (TMNTLocation *)initWithCurrentLocationAndUpdates;

@end

