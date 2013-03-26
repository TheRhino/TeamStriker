//
//  YelpClick.h
//  TakeMeNearThere
//
//  Created by RHINO on 3/26/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface YelpClick : NSManagedObject

@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * timestamp;

@end
