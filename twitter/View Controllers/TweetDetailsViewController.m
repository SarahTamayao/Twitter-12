//
//  TweetDetailsViewController.m
//  twitter
//
//  Created by Sanjana Meduri on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "UIImageView+AFNetworking.h" //to add methods to ImageView
#import "NSDate+DateTools.h"
#import "APIManager.h"

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
    // Do any additional setup after loading the view.
    
    [self loadData];
}

- (void) loadData{
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.pfpView.image = nil; //clears out image from previous self so that when it lags, the previous image doesn't show up
    [self.pfpView setImageWithURL:url];
    
    //set name
    self.usernameLabel.text = self.tweet.user.name;
    
    //set handle
    self.userhandleLabel.text = [@"@" stringByAppendingString: self.tweet.user.screenName];
    
    //set date
    NSString *dateStr = self.tweet.createdAtString;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"E MMM d HH:mm:ss Z y"];

    NSDate *tweetDate = [dateFormat dateFromString:dateStr];
    
    self.dateLabel.text = tweetDate.shortTimeAgoSinceNow;
    
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

-(void) fetchTweet{
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweet = tweets[self.indexPath.row];
            NSLog(@"😎😎😎 Successfully loaded tweet");
            for (Tweet *t in tweets) {
                NSString *text = t.text;
                NSLog(@"%@", text);
            }
        } else {
            NSLog(@"😫😫😫 Error getting tweet: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapRefresh:(id)sender {
    [self fetchTweet];
    [self loadData];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
