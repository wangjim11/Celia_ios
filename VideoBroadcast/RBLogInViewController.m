//
//  RBLogInViewController.m
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/10/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import "RBLogInViewController.h"
#import "RBSignUpViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

#define IS_IPAD                     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface RBLogInViewController ()

@end

@implementation RBLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showForgotPWD = NO;
    self.showTrademark = NO;
    self.showCornerLogo = NO;
    self.showCopyRight = NO;
    
    self.appLabelString = @"ROBOTEX";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Overwrite

#pragma mark - Overwrite

- (void)settingsAction {
    RBSignUpViewController *signup = [[RBSignUpViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:signup];
    
    if (IS_IPAD) {
        
    }else{
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)logInAction {
    [super logInAction];
    
    __weak RBLogInViewController *weakSelf = self;
    [PFUser logInWithUsernameInBackground:self.nameString password:self.pwdString block:^(PFUser *user, NSError *error) {
        if (user) {
            [weakSelf logInSuccessAction];
        }else{
            [weakSelf logInFailedAction];
        }
    }];
}

- (void)logInSuccessAction {
    [super logInSuccessAction];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateRootViewController];
}

- (void)logInFailedAction {
    [super logInFailedAction];
}


@end
