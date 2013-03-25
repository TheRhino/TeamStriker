//
//  TMNTCell.m
//  TakeMeNearThere
//
//  Created by Dexter Teng on 3/21/13.
//  Copyright (c) 2013 Heroes in a Half Shell. All rights reserved.
//

#import "TMNTCell.h"

@implementation TMNTCell

- (void)pullImageFromStringURL:(NSString *)urlString appendDictionary:(NSMutableDictionary *)dictionary onImageView:(UIImageView *)imageView
{
    imageView.image = [UIImage imageNamed:@"toilet-inverted.jpg"];
    dispatch_queue_t myqueue = dispatch_queue_create("pictureBuilderQueue", NULL);
    dispatch_async(myqueue, ^(void)
                   {
                       
                       UIImage *flickrImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
                       [dictionary setValue:flickrImage forKey:urlString];
                       
                       dispatch_async(dispatch_get_main_queue(), ^(void)
                                      {
                                          imageView.image = flickrImage;
                                      });
                   });
    
}

- (TMNTCell *)initWithStyle:(UITableViewCellStyle)uiTableViewCellStyle reuseIdentifier:(NSString *)cellID
{
    self = [super initWithStyle:uiTableViewCellStyle reuseIdentifier:cellID];
    return self;
}
@end
