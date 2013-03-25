//
//  YelpClick.h
//  TakeMeNearThere
//
//  Created by Dexter Teng on 3/25/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface YelpClick : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString *favorite;

@end
