//
//  TMNTViewController.m
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/5/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import "TMNTViewController.h"
#import "TMNTLocation.h"
#import "TMNTAPIProcessor.h"

@interface TMNTViewController ()
{
    TMNTAPIProcessor *yelpProcess;
}
@end

@implementation TMNTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    //test that tmntlocation works
//    TMNTLocation *userLocation = [[TMNTLocation alloc] init];
//    NSLog(@"%f",userLocation.location.longitude);
    TMNTLocation *location = [[TMNTLocation alloc] init];
//    TMNTAPIProcessor *flickrProcess = [[TMNTAPIProcessor sharedInstance]initWithFlickrSearch:@"hamburger" andLocation:location];
//    [flickrProcess getFlickrJSON];
//    NSLog(@"this is the %@", [flickrProcess flickrPhotosArray]);

    yelpProcess = [[TMNTAPIProcessor alloc]initWithYelpSearch:@"food" andLocation:location];
    

    NSLog(@"I AM THE VIEW START PROCESS");
    [yelpProcess getYelpJSON];
    NSLog(@"I AM THE VIEW END PROCESS");
	// Do any additional setup after loading the view, typically from a nib.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
