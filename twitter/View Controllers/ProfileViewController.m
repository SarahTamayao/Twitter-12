//
//  ProfileViewController.m
//  twitter
//
//  Created by Sanjana Meduri on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "APIManager.h"
#import "User.h"
#import "UIImageView+AFNetworking.h" //to add methods to ImageView

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bannerView;
@property (weak, nonatomic) IBOutlet UIImageView *pfpView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *verifiedIcon;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followersCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;

@property (nonatomic, strong) NSDictionary *userProfile;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchProfile];
}

- (void) fetchProfile{
    [[APIManager shared] getUserProfileWithCompletion:(self.myUser):^(NSDictionary *userProfile, NSError *error) {
        if (userProfile) {
            self.userProfile = userProfile;
            NSLog(@"😎😎😎 Successfully loaded user profile");
            [self loadProfile];
//            for (Tweet *t in tweets) {
//                NSString *text = t.text;
//                NSLog(@"%@", text);
//            }
        } else {
            NSLog(@"😫😫😫 Error getting followers: %@", error.localizedDescription);
        }
    }];
}

- (void) loadProfile{
    self.screenNameLabel.text = self.userProfile[@"name"];
    self.handleLabel.text = [@"@" stringByAppendingString:self.userProfile[@"screen_name"]];

    NSString *URLString = self.userProfile[@"profile_image_url"];
    NSLog(URLString);
    NSURL *url = [NSURL URLWithString:URLString];
    self.pfpView.image = nil; //clears out image from previous self so that when it lags, the previous image doesn't show up
    [self.pfpView setImageWithURL:url];
    
    NSString *bgURLString = self.userProfile[@"profile_banner_url"];
    NSURL *bgUrl = [NSURL URLWithString:bgURLString];
    self.bannerView.image = nil; //clears out image from previous self so that when it lags, the previous image doesn't show up
    [self.bannerView setImageWithURL:bgUrl];
    
    if (self.userProfile[@"verified"]){
        self.verifiedIcon.alpha = 1;
    }
    else {self.verifiedIcon.alpha = 0;}
    
    self.bioLabel.text = self.userProfile[@"description"];
    
    self.favoriteCount.text = [NSString stringWithFormat:@"%@", self.userProfile[@"favourites_count"]];
    
    self.followersCount.text = [NSString stringWithFormat:@"%@", self.userProfile[@"followers_count"]];
    
    self.followingCount.text = [NSString stringWithFormat:@"%@", self.userProfile[@"friends_count"]];
    
    if(self.userProfile[@"following"]){
        self.followingButton.backgroundColor = [UIColor systemBlueColor];
        self.followingButton.titleLabel.text = @"Following";
        [self.followingButton setTitle:@"Following" forState:UIControlStateNormal];
        [self.followingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else{
        self.followingButton.backgroundColor = [UIColor whiteColor];
        [self.followingButton setTitle:@"Follow" forState:UIControlStateNormal];
        [self.followingButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    }
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
