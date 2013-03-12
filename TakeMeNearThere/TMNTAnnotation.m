//
//  TMNTAnnotation.m
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/11/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import "TMNTAnnotation.h"

@implementation TMNTAnnotation
@synthesize coordinate,title,subtitle;

- initWithPosition:(CLLocationCoordinate2D *)coords
{
    if (self = [super init]) {
        self.coordinate = *(coords);
    }
    return self;
}

@end
