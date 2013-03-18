//
//  YelpClick.h
//  TakeMeNearThere
//
//  Created by Nirav Amin on 3/14/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface YelpClick : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end
