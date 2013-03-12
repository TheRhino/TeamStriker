//
//  TMNTAnnotation.h
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/11/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TMNTAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

- initWithPosition:(CLLocationCoordinate2D *)coords;

@end
