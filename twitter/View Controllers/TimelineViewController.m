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
#import "UIImageView+AFNetworking.h" //to add methods to ImageView

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    NSLog(@"hello");
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchTweets];
    
    self.refreshControl = [[UIRefreshControl alloc] init]; //initializing pull to refresh control
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged]; //call fetchMovies on self when UIControlEventValueChanged
    [self.refreshControl setTintColor:[UIColor blueColor]];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
}

-(void) fetchTweets{
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayOfTweets = tweets;
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *t in tweets) {
                NSString *text = t.text;
                NSLog(@"%@", text);
            }
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
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutClicked:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //set inital cell
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    //get tweet
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    cell.tweet = tweet;
    
    //set pfp
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    cell.pfpView.image = nil; //clears out image from previous cell so that when it lags, the previous image doesn't show up
    [cell.pfpView setImageWithURL:url];
    
    //set name
    cell.usernameLabel.text = tweet.user.name;
    
    //set handle
    cell.userhandeLabel.text = [@"@" stringByAppendingString: tweet.user.screenName];
    
    //set date
    cell.dateLabel.text = tweet.createdAtString;
    
    //set text
    cell.textLabel.text = tweet.text;
    
    //set retweeted
    UIImage *rticon = [UIImage imageNamed:@"retweet-icon"];
    if(tweet.retweeted) rticon = [UIImage imageNamed:@"retweet-icon-green"];
    [cell.retweetIcon setImage:rticon forState:UIControlStateNormal];
    
    //set retweet count
    cell.retweetCountLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    
    //set favorited
    UIImage *favoricon = [UIImage imageNamed:@"favor-icon"];
    if(tweet.favorited) favoricon = [UIImage imageNamed:@"favor-icon-red"];
    [cell.favoriteIcon setImage:favoricon forState:UIControlStateNormal];
    
    //set favorite count
    cell.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayOfTweets count];
}


@end
