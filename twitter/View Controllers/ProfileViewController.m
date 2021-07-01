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

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) fetchFollowers{
    [[APIManager shared] getFollowersWithCompletion:(self.user):^(NSMutableArray *followers, NSError *error) {
        if (followers) {
            self.user.followers = followers;
            NSLog(@"😎😎😎 Successfully loaded followers");
//            for (Tweet *t in tweets) {
//                NSString *text = t.text;
//                NSLog(@"%@", text);
//            }
        } else {
            NSLog(@"😫😫😫 Error getting followers: %@", error.localizedDescription);
        }
    }];
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
