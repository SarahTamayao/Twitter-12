//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "../API/APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"
#import "TweetDetailsViewController.h"
#import "ComposeViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchTweets];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setTintColor:[UIColor blueColor]];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

-(void) fetchTweets{
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayOfTweets = tweets;
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

-(void) loadMoreTweets:(NSInteger *) count{
    [[APIManager shared] getMoreHomeTimelineWithCompletion:count:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayOfTweets = tweets;
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (IBAction)manualRefresh:(id)sender {
    [self fetchTweets];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//this function was pulled from codepath
- (IBAction)logoutClicked:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    cell.tweet = tweet;
    
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    cell.pfpView.image = nil; //clears out image from previous cell so that when it lags, the previous image doesn't show up
    [cell.pfpView setImageWithURL:url];
    
    cell.usernameLabel.text = tweet.user.name;
    
    cell.userhandeLabel.text = [@"@" stringByAppendingString: tweet.user.screenName];
    
    NSString *dateStr = tweet.createdAtString;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"E MMM d HH:mm:ss Z y"];

    NSDate *tweetDate = [dateFormat dateFromString:dateStr];
    
    cell.dateLabel.text = tweetDate.shortTimeAgoSinceNow;
    
    cell.textLabel.text = tweet.text;
    
    UIImage *rticon = [UIImage imageNamed:@"retweet-icon"];
    if(tweet.retweeted) rticon = [UIImage imageNamed:@"retweet-icon-green"];
    [cell.retweetIcon setImage:rticon forState:UIControlStateNormal];
    
    cell.retweetCountLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    
    UIImage *favoricon = [UIImage imageNamed:@"favor-icon"];
    if(tweet.favorited) favoricon = [UIImage imageNamed:@"favor-icon-red"];
    [cell.favoriteIcon setImage:favoricon forState:UIControlStateNormal];
    
    cell.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayOfTweets count];
}

- (void) didTweet:(Tweet *)tweet{
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    int additionalTweetsCount = 20;
    if(indexPath.row + 1 == [self.arrayOfTweets count]){
        [self loadMoreTweets:([self.arrayOfTweets count] + additionalTweetsCount)];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {    
    if ([segue.identifier isEqual:@"tweetDetails"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.arrayOfTweets[indexPath.row];
        
        TweetDetailsViewController *tweetViewController = [segue destinationViewController];
        tweetViewController.tweet = tweet;
        tweetViewController.indexPath = indexPath;
    }
    
    if ([segue.identifier isEqual:@"composeTweet"]){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    
}



@end
