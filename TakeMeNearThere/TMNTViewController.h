//
//  TMNTViewController.h
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/5/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMNTDataSourceDelegate.h"


@interface TMNTViewController : UIViewController <TMNTDataSourceDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) NSMutableArray *returnedArray;
@property (strong, nonatomic) NSMutableArray *flickrReturnedArray;
@property NSManagedObjectContext *myManagedObjectContext;
@property (nonatomic, strong) CLLocationManager *locationManager;


-(void)addPinsToMap;

@end