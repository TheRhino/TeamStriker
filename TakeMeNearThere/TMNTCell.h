//
//  TMNTCell.h
//  TakeMeNearThere
//
//  Created by Dexter Teng on 3/21/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMNTCell : UITableViewCell

- (void)pullImageFromStringURL:(NSString *)urlString appendDictionary:(NSMutableDictionary *)dictionary onImageView:(UIImageView *)imageView;

@end
