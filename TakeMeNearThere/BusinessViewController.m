//
//  BusinessViewController.m
//  TakeMeNearThere
//
//  Created by Nirav Amin on 3/20/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import "BusinessViewController.h"


@interface BusinessViewController ()
{
    IBOutlet UILabel *businessNameLabel;
    IBOutlet UILabel *neighborhoodLabel;
    IBOutlet UIImageView *businessImage;
    IBOutlet UILabel *streetAddress;
    IBOutlet UILabel *cityStateZip;
    IBOutlet UIImageView *ratingReviewImage;
    IBOutlet UILabel *phone;
    
    
}

@end

@implementation BusinessViewController


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
    businessNameLabel.text=self.businessName;
    neighborhoodLabel.text=self.neighborhoodName;
    businessImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.businessURL]]];
    streetAddress.text = self.businessStreetAddress;
    cityStateZip.text = self.businessCityStateZip;
    phone.text = self.businessphone;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
