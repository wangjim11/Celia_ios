//
//  RBSubscriberViewController.m
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/13/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import "RBSubscriberViewController.h"
#import "RBCamera.h"
#import "RBOPTSessionManager.h"
#import "UIView+ViewConstraints.h"

@interface RBSubscriberViewController () <RBOpenTokSubscriberDelegate>
@property (nonatomic, strong) UIView    *containerView;
@end

@implementation RBSubscriberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _containerView = ({
        UIView *aView = [[UIView alloc] initWithFrame:CGRectZero];
        aView.backgroundColor = [UIColor whiteColor];
        aView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:aView];
        [aView addConstraintsToFillSuperview];
        
        aView;
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [self startSession];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - OpenTok Session Manager

- (void)startSession {
    if (_camera.isAvailable) {
        [RBOPTSessionManager sharedInstance].subscriberDelegate = self;
        [[RBOPTSessionManager sharedInstance] subscribeToCamera:_camera];
    }
}


#pragma mark - RBOpenTokSubscriberDelegate Methods

- (void)subscriberSessionDidFail:(OTSession *)session error:(NSError *)error {
    [self displayMessage:@"Subscriber session failed"];
}

- (void)subscriberDidConnected:(OTSubscriber *)subscriber {
    subscriber.view.translatesAutoresizingMaskIntoConstraints = NO;
    [_containerView addSubview:subscriber.view];
    [subscriber.view addConstraintsToFillSuperview];
}

- (void)subscriberDidDisconnected:(OTSubscriber *)subscriber {
    [subscriber.view removeFromSuperview];
}

- (void)subscriberDidFail:(OTSubscriber *)subscriber error:(NSError *)error {
    [self displayMessage:@"Subscriber failed"];
}


#pragma mark - Helper Methods

- (void)displayMessage:(NSString *)string {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:string preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

