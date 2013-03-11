//
//  TMNTLocation.m
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/5/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import "TMNTLocation.h"

@implementation TMNTLocation
@synthesize coordinate;

//make our own version of cllocation, that currently is hard coded to MM
- (TMNTLocation*)init
{
    self = [super init];
    coordinate.latitude = 41.894032;
    coordinate.longitude = -87.634742;
    return self;
}

@end

