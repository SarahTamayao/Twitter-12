//
//  ComposeViewController.m
//  twitter
//
//  Created by Sanjana Meduri on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *composeTextView;
@property (weak, nonatomic) IBOutlet UILabel *characterCount;
@property (nonatomic, strong) NSDictionary *userProfile;
@property (weak, nonatomic) IBOutlet UIImageView *pfpView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.composeTextView.delegate = self;
    self.composeTextView.layer.borderWidth = 2.0f;
    self.composeTextView.layer.borderColor = [[UIColor systemBlueColor] CGColor];
    self.composeTextView.layer.cornerRadius = 8;
    
    [self fetchUser];
}

- (IBAction)onTweet:(id)sender {
    [[APIManager shared] postStatusWithText:(self.composeTextView.text) completion:^(Tweet * tweet, NSError * error) {
        if (error != nil){
            NSLog(@"😫😫😫 Error posting tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)repText{
    int characterLimit = 140;
    NSString *newText = [self.composeTextView.text stringByReplacingCharactersInRange:range withString:repText];
    if(newText.length >= characterLimit) {
        self.characterCount.text = @"max character count reached";
        self.characterCount.textColor = [UIColor redColor];
    }
    else{
        self.characterCount.text = [NSString stringWithFormat:@"%d", newText.length];
        self.characterCount.textColor = [UIColor blackColor];
    }
    return newText.length < characterLimit;
}

- (void) fetchUser{
    [[APIManager shared] getMyProfileWithCompletion:^(NSDictionary *myProfile, NSError *error) {
        if (myProfile) {
            self.userProfile = myProfile;
            [self loadImage];
        } else {
            NSLog(@"😫😫😫 Error getting my profile: %@", error.localizedDescription);
        }
    }];
}

- (void) loadImage{
    NSString *URLString = self.userProfile[@"profile_image_url"];
    NSURL *url = [NSURL URLWithString:URLString];
    self.pfpView.image = nil;
    [self.pfpView setImageWithURL:url];
}


@end
