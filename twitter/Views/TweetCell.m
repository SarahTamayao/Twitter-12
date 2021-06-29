//
//  self.tweetself.m
//  twitter
//
//  Created by Sanjana Meduri on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h" //to add methods to ImageView

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshData{
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.pfpView.image = nil; //clears out image from previous self so that when it lags, the previous image doesn't show up
    [self.pfpView setImageWithURL:url];
    
    //set name
    self.usernameLabel.text = self.tweet.user.name;
    
    //set handle
    self.userhandeLabel.text = [@"@" stringByAppendingString: self.tweet.user.screenName];
    
    //set date
    self.dateLabel.text = self.tweet.createdAtString;
    
    //set text
    self.textLabel.text = self.tweet.text;
    
    //set retweeted
    UIImage *rticon = [UIImage imageNamed:@"retweet-icon"];
    if(self.tweet.retweeted) rticon = [UIImage imageNamed:@"retweet-icon-green"];
    [self.retweetIcon setImage:rticon forState:UIControlStateNormal];
    
    //set retweet count
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    
    //set favorited
    UIImage *favoricon = [UIImage imageNamed:@"favor-icon"];
    if(self.tweet.favorited) favoricon = [UIImage imageNamed:@"favor-icon-red"];
    [self.favoriteIcon setImage:favoricon forState:UIControlStateNormal];
    
    //set favorite count
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
}

- (IBAction)didTapRetweet:(id)sender {
    NSLog(@"tapped retweet");
    if (self.tweet.retweeted){
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
    }
    else{
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
    }
    
    [self refreshData];
}


- (IBAction)didTapFavorite:(id)sender {
    NSLog(@"tapped favorite");
    if (self.tweet.favorited){
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
    }
    else{
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
    }
    
    [self refreshData];
}

@end
