//
//  TMNTPlace.h
//  TakeMeNearThere
//
//  Created by Dexter Teng on 3/7/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TMNTDataSourceDelegate.h"
#import "TMNTLocation.h"

@interface TMNTPlace : NSObject

@property (strong, nonatomic) TMNTLocation *location;
@property (strong, nonatomic) NSString *name;


@end
