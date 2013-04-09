//
//  FavoritesTableViewController.m
//  TakeMeNearThere
//
//  Created by RHINO on 3/25/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import "FavoritesTableViewController.h"
#import "TMNTAppDelegate.h"
#import "YelpClick.h"
#import "TMNTAppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface FavoritesTableViewController ()
{
    NSArray *yelpFavorites;
    IBOutlet UITableView *myFavTableView;
}

@end

@implementation FavoritesTableViewController

@synthesize favManagedObjectContext;
//@synthesize favorite;


- (void)viewDidLoad
{
    [super viewDidLoad];
    yelpFavorites = [self getYelpFavorites];
    [myFavTableView reloadData];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    //[super viewWillAppear:animated];
//    
//}

-(NSArray *)getYelpFavorites
{
    TMNTAppDelegate *appDelegate = (TMNTAppDelegate*) [[UIApplication sharedApplication] delegate];
    favManagedObjectContext = appDelegate.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"YelpClick" inManagedObjectContext:favManagedObjectContext];
    NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
    
    fetchRequest.predicate = [self getViewPredicate];
    NSError *error;
    fetchRequest.entity = entityDescription;
    return [favManagedObjectContext executeFetchRequest:fetchRequest error:&error];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (yelpFavorites.count == 0) {
        return 0;
    }else
    {
        return yelpFavorites.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"clickFavoritesCell"];
    
    if (tableViewCell == nil)
    {
        tableViewCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"clickFavoritesCell"];
    }
    
    UIView *yelpClickViewToLabel = [tableViewCell viewWithTag:100];
    UILabel *yelpClickLabel = (UILabel *)yelpClickViewToLabel;
    
    yelpClickLabel.text = [[yelpFavorites objectAtIndex:[indexPath row]]valueForKey:@"name"];
    tableViewCell.backgroundColor = [UIColor colorWithRed:0.0f green:0.1f blue:0.34f alpha:0.33f];
    return tableViewCell;
}

-(void)deleteFavorite:(YelpClick *)yelpClickFavorite
{
    TMNTAppDelegate *appDelegate = (TMNTAppDelegate *)[[UIApplication sharedApplication] delegate];
    favManagedObjectContext = appDelegate.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"YelpClick" inManagedObjectContext:favManagedObjectContext];
    NSFetchRequest *fetchRequest =[[NSFetchRequest alloc] init];
    NSError *error;
    fetchRequest.entity = entityDescription;
    NSArray *pastClicks = [favManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // REPLACE WITH PREDICATE LATER
    for (YelpClick *pastClick in pastClicks)
    {
        if ([pastClick.name isEqualToString:yelpClickFavorite.name])
        {
            pastClick.favorite = [NSNumber numberWithBool:NO];
            NSError *firstError;
            [self saveWithError:firstError];
        }
        
    }

}

-(void)saveWithError:(NSError*)error
{
    if (![self.favManagedObjectContext save:&error])
    {
        NSLog(@"Failed because:%@",[error userInfo]);
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Favorites *favoriteRecord = [yelpFavorites objectAtIndex:[indexPath row]];
    
    [self deleteFavorite:favoriteRecord];
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView reloadData];
    
    yelpFavorites = [self getYelpFavorites];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSPredicate *)getViewPredicate
{
    NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"favorite == true"];
    
    return myPredicate;
}

@end
