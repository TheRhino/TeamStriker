//
//  FavoritesTableViewController.m
//  TakeMeNearThere
//
//  Created by RHINO on 3/25/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import "FavoritesTableViewController.h"
#import "YelpClick.h"

@interface FavoritesTableViewController ()

@end

@implementation FavoritesTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSPredicate *)getViewPredicate
{
    NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"favorite == true"];
    
    return myPredicate;
}

@end
