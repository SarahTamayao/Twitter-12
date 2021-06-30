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

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *composeTextView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.composeTextView.layer.borderWidth = 2.0f;
    self.composeTextView.layer.borderColor = [[UIColor systemBlueColor] CGColor];
    self.composeTextView.layer.cornerRadius = 8;
}

- (IBAction)onTweet:(id)sender {
    [[APIManager shared] postStatusWithText:(self.composeTextView.text) completion:^(Tweet * tweet, NSError * error) {
        if (error != nil){
            NSLog(@"😫😫😫 Error posting tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            NSLog(@"Tweet posted!");
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
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
