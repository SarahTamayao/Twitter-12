//
//  TweetDetailsViewController.m
//  twitter
//
//  Created by Sanjana Meduri on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"
#import "APIManager.h"
#import "ProfileViewController.h"

@interface TweetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pfpView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userhandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetIcon;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteIcon;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;

@end

@implementation TweetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
}

- (void) loadData{
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.pfpView.image = nil;
    [self.pfpView setImageWithURL:url];
    
    self.usernameLabel.text = self.tweet.user.name;
    
    self.userhandleLabel.text = [@"@" stringByAppendingString: self.tweet.user.screenName];
    
    NSString *dateStr = self.tweet.createdAtString;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"E MMM d HH:mm:ss Z y"];

    NSDate *tweetDate = [dateFormat dateFromString:dateStr];
    
    self.dateLabel.text = tweetDate.shortTimeAgoSinceNow;
    
    self.textLabel.text = self.tweet.text;
    
    UIImage *rticon = [UIImage imageNamed:@"retweet-icon"];
    if(self.tweet.retweeted) rticon = [UIImage imageNamed:@"retweet-icon-green"];
    [self.retweetIcon setImage:rticon forState:UIControlStateNormal];
    
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    
    UIImage *favoricon = [UIImage imageNamed:@"favor-icon"];
    if(self.tweet.favorited) favoricon = [UIImage imageNamed:@"favor-icon-red"];
    [self.favoriteIcon setImage:favoricon forState:UIControlStateNormal];
    
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
}

-(void) fetchTweet{
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweet = tweets[self.indexPath.row];
        } else {
            NSLog(@"😫😫😫 Error getting tweet: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapRefresh:(id)sender {
    [self fetchTweet];
    [self loadData];
}

- (IBAction)didTapRetweet:(id)sender {
    if (self.tweet.retweeted){
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        
        // TODO: Send a POST request to the POST favorites/destory endpoint
         [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
             }
         }];
    }
    else{
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        
        // TODO: Send a POST request to the POST favorites/create endpoint
         [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
             }
         }];
    }
    
    [self loadData];
}

- (IBAction)didTapFavorite:(id)sender {
    if (self.tweet.favorited){
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
        // TODO: Send a POST request to the POST favorites/destory endpoint
         [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
             }
         }];
    }
    else{
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        
        // TODO: Send a POST request to the POST favorites/create endpoint
         [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
         }];
    }
    
    [self loadData];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ProfileViewController *profileViewController = [segue destinationViewController];
    profileViewController.myUser = self.tweet.user;
}


@end
