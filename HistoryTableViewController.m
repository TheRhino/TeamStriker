//
//  HistoryTableViewController.m
//  TakeMeNearThere
//
//  Created by Nirav Amin on 3/14/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "TMNTAppDelegate.h"
#import "YelpClick.h"




@interface HistoryTableViewController ()

@end




@implementation HistoryTableViewController

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
	// Do any additional setup after loading the view.
}

-(NSArray*)getYelpHistory
{
    TMNTAppDelegate *appDelegate = (TMNTAppDelegate*) [[UIApplication sharedApplication] delegate];
    myManagedObjectContext = appDelegate.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"YelpClick" inManagedObjectContext:myManagedObjectContext];
    NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
    NSError *error;
    fetchRequest.entity = entityDescription;
    return [myManagedObjectContext executeFetchRequest:fetchRequest error:&error];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self getYelpHistory].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"clickHistoryCell"];
    if (tableViewCell == nil)
    {
        tableViewCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"clickHistoryCell"];
    }
    NSArray* yelpHistory= [myManagedObjectContext valueForKey:@"name"];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
