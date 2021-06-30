//
//  TweetDetailsViewController.h
//  twitter
//
//  Created by Sanjana Meduri on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetDetailsViewController : UIViewController

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
