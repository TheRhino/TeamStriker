//
//  FavoritesTableViewController.h
//  TakeMeNearThere
//
//  Created by RHINO on 3/25/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import "HistoryTableViewController.h"

@class Favorites;

@interface FavoritesTableViewController : HistoryTableViewController <UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate>

@property NSManagedObjectContext *favManagedObjectContext;
@end
