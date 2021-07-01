//
//  UserViewController.m
//  twitter
//
//  Created by Sanjana Meduri on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "UserViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h" //to add methods to ImageView

@interface UserViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bannerView;
@property (weak, nonatomic) IBOutlet UIImageView *pfpView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followersCount;
@property (weak, nonatomic) IBOutlet UILabel *favoritesCount;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;

@property (nonatomic, strong) NSDictionary *userProfile;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self fetchUser];
}


- (void) fetchUser{
    [[APIManager shared] getMyProfileWithCompletion:^(NSDictionary *myProfile, NSError *error) {
        if (myProfile) {
            self.userProfile = myProfile;
            [self loadProfile];
        } else {
            NSLog(@"😫😫😫 Error getting my profile: %@", error.localizedDescription);
        }
    }];
}

- (void) loadProfile{
    self.nameLabel.text = self.userProfile[@"name"];
    self.handleLabel.text = [@"@" stringByAppendingString:self.userProfile[@"screen_name"]];

    NSString *URLString = self.userProfile[@"profile_image_url"];
    NSURL *url = [NSURL URLWithString:URLString];
    self.pfpView.image = nil; //clears out image from previous self so that when it lags, the previous image doesn't show up
    [self.pfpView setImageWithURL:url];

    NSString *bgURLString = self.userProfile[@"profile_banner_url"];
    NSURL *bgUrl = [NSURL URLWithString:bgURLString];
    self.bannerView.image = nil; //clears out image from previous self so that when it lags, the previous image doesn't show up
    [self.bannerView setImageWithURL:bgUrl];

    self.bioLabel.text = self.userProfile[@"description"];

    self.favoritesCount.text = [NSString stringWithFormat:@"%@", self.userProfile[@"favourites_count"]];

    self.followersCount.text = [NSString stringWithFormat:@"%@", self.userProfile[@"followers_count"]];

    self.followingCount.text = [NSString stringWithFormat:@"%@", self.userProfile[@"friends_count"]];
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
