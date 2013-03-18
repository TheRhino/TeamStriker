//
//  TMNTViewController.h
//  TakeMeNearThere
//
//  Created by Nathan Levine on 3/5/13.
//  Copyright (c) 2013 Nathan Levine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMNTDataSourceDelegate.h"


@interface TMNTViewController : UIViewController <TMNTDataSourceDelegate>

@property (strong, nonatomic) NSMutableArray *returnedArray;
@property NSManagedObjectContext *myManagedObjectContext;


-(void)addPinsToMap;

@end



/* //things i(Nathan) did
 
 1. make new annotation class
 2. in annotation class import mapkit framework
 3. make annotation class an <mkannotation> delegate
 4. add title, subtitle, and coordinate properties and synthesize dem badboys
 
 5. import annotation.h to vc.m
 6. make new method in vc (addPinsToMap)
 7. import coreloaction framework to vc.m --Shouldnt matter didnt do again
 8. gave returnedArray class scope instead of just method local scope
 9. added custom init to annotation class
 10. added stuff to addpins method
 
 11.CANT GET IT TO CALL WTF --NVM GOT IT!!:)
 
 12. added users location (checkbox :))
 13.make region normal so you dont have to zoom like crazy
 14. made tmnt location  *location an instance variable

 
 
 
*/