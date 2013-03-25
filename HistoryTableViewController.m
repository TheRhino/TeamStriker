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
{
    NSArray* yelpHistory;
    IBOutlet UITableView *myTableView;
}

@end

@implementation HistoryTableViewController

@synthesize myManagedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    yelpHistory = [self getYelpHistory];
    [myTableView reloadData];
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

    UIView *yelpClickViewToLabel = [tableViewCell viewWithTag:100];
    UILabel *yelpClickLabel = (UILabel *)yelpClickViewToLabel;
    
    yelpClickLabel.text = [[yelpHistory objectAtIndex:[indexPath row]]valueForKey:@"name"];
    tableViewCell.backgroundColor = [UIColor colorWithRed:0.0f green:0.1f blue:0.35f alpha:0.65f];//colorWithCIColor:[CIColor colorWithRed:0.0f green:0.01f blue:0.75f alpha:0.85]];
    return tableViewCell;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    yelpHistory = [self getYelpHistory];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSPredicate *)getViewPredicate
{
    NSPredicate *myPredicate = nil;
    
    return myPredicate;
}

@end
