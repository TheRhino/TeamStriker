//
//  TMNTLocation.h
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/5/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface TMNTLocation : CLLocation

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

- (TMNTLocation*)init;

@end

