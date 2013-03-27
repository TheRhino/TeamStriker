//
//  BusinessViewController.m
//  TakeMeNearThere
//
//  Created by Nirav Amin on 3/20/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import "BusinessViewController.h"
#import "YelpClick.h"
#import <CoreLocation/CoreLocation.h>
#import "TMNTAppDelegate.h"


@interface BusinessViewController ()
{
    IBOutlet UILabel *businessNameLabel;
    IBOutlet UILabel *neighborhoodLabel;
    IBOutlet UIImageView *businessImage;
    IBOutlet UILabel *streetAddress;
    IBOutlet UILabel *cityStateZip;
    IBOutlet UIImageView *ratingReviewImage;
    IBOutlet UILabel *phone;
    IBOutlet UILabel *rating;
    IBOutlet UILabel *distance;
    IBOutlet UILabel *category;
    IBOutlet UIImageView *reviewPic;
    
}

-(IBAction)favorite:(id)sender;

@end

@implementation BusinessViewController 

@synthesize myManagedObjectContext;

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
    [reviewPic setImage:[UIImage imageNamed:@"ReviewPic.jpg"]];
    businessNameLabel.text=self.businessName;
    neighborhoodLabel.text=self.neighborhoodName;
    businessImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.businessURL]]];
    streetAddress.text = self.businessStreetAddress;
    cityStateZip.text = self.businessCityStateZip;
    phone.text = [NSString stringWithFormat: @"%@-%@-%@", [self.businessphone substringWithRange:NSMakeRange(0,3)],[self.businessphone substringWithRange:NSMakeRange(3,3)],
                  [self.businessphone substringWithRange:NSMakeRange(6,4)]];
    rating.text= [NSString stringWithFormat:@"%@",self.averageRating];
    category.text = self.businessCategory;
    distance.text = [NSString stringWithFormat:@"%@",self.distanceFromCurrentLocation];
	// Do any additional setup after loading the view.
}

-(IBAction)favorite:(id)sender
{
    TMNTAppDelegate *appDelegate = (TMNTAppDelegate *)[[UIApplication sharedApplication] delegate];
    myManagedObjectContext = appDelegate.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"YelpClick" inManagedObjectContext:myManagedObjectContext];
    NSFetchRequest *fetchRequest =[[NSFetchRequest alloc] init];
    NSError *error;
    fetchRequest.entity = entityDescription;
    NSArray *pastClicks = [myManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // REPLACE WITH PREDICATE LATER
    for (YelpClick *pastClick in pastClicks)
    {
        if ([pastClick.name isEqualToString:self.businessName])
        {
            pastClick.favorite = [NSNumber numberWithBool:YES];
            NSError *error;
            [self saveWithError:error];
        }

    }
    
}

-(void)saveWithError:(NSError*)error
{
    if (![self.myManagedObjectContext save:&error])
    {
        NSLog(@"Failed because:%@",[error userInfo]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
