//
//  HistoryTableViewController.h
//  TakeMeNearThere
//
//  Created by Nirav Amin on 3/14/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property NSManagedObjectContext *myManagedObjectContext;

@end
