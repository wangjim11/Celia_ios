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
@property (nonatomic, strong) UILabel                   *optSesstionTitleLabel;
@property (nonatomic, strong) UIView                    *optSessionView;
@property (nonatomic, strong) UISwitch                  *optSessionSwitch;
@property (nonatomic, strong) UIActivityIndicatorView   *optIndicatorView;
@end

@implementation RBSubscriberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _optSessionView = ({
        UIView *aView = [[UIView alloc] initWithFrame:CGRectZero];
        aView.backgroundColor = [UIColor blackColor];
        aView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:aView];
        [aView addConstraintsToFillSuperview];
        
        aView;
    });
    
    _optSesstionTitleLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:label];
        
        NSArray *hCN = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(30)-[label]-(30)-|" options:0 metrics:nil views:@{@"label":label}];
        [self.view addConstraints:hCN];
        
        NSLayoutConstraint *topCN = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:45];
        [self.view addConstraint:topCN];
        
        label;
    });
    
    _optSessionSwitch = ({
        UISwitch *aSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        aSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        [aSwitch setOn:NO animated:NO];        
        [aSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:aSwitch];
        
        NSLayoutConstraint *centerXCN = [NSLayoutConstraint constraintWithItem:aSwitch attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        [self.view addConstraint:centerXCN];
        
        NSLayoutConstraint *bottomCN = [NSLayoutConstraint constraintWithItem:aSwitch attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-50];
        [self.view addConstraint:bottomCN];
        
        aSwitch;
    });
    
    _optIndicatorView = ({
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.hidesWhenStopped = YES;
        indicator.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:indicator];
        
        NSLayoutConstraint *centerXCN = [NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        [self.view addConstraint:centerXCN];
        
        NSLayoutConstraint *centerYCN = [NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [self.view addConstraint:centerYCN];
        
        indicator;
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI Action Methods

- (void)displayLoadingStartedUI {
    _optSessionSwitch.enabled = NO;
    [_optIndicatorView startAnimating];
}

- (void)displayLoadingFinishedUI {
    _optSessionSwitch.enabled = YES;
    [_optIndicatorView stopAnimating];
}

- (void)switchValueChanged:(UISwitch *)aSwitch {
    if (_camera.isAvailable) {
        if (_camera.isAvailable) {
            [self startSession];
        }else{
            [self stopSession];
        }
    }
}


#pragma mark - OpenTok Session Manager

- (void)startSession {
    if (_camera.isAvailable) {
        [self displayLoadingStartedUI];
        [RBOPTSessionManager sharedInstance].subscriberDelegate = self;
        [[RBOPTSessionManager sharedInstance] subscribeToCamera:_camera];
    }
}

- (void)stopSession {
    [[RBOPTSessionManager sharedInstance] unsubscribeFromCamera:_camera];
    [self displayLoadingFinishedUI];
}


#pragma mark - RBOpenTokSubscriberDelegate Methods

- (void)subscriberSessionDidFail:(OTSession *)session error:(NSError *)error {
    [self displayMessage:@"Subscriber session failed"];
    [self displayLoadingFinishedUI];
}

- (void)subscriberDidConnected:(OTSubscriber *)subscriber {
    subscriber.view.translatesAutoresizingMaskIntoConstraints = NO;
    [_optSessionView addSubview:subscriber.view];
    [subscriber.view addConstraintsToFillSuperview];
    [self displayLoadingFinishedUI];
}

- (void)subscriberDidDisconnected:(OTSubscriber *)subscriber {
    [subscriber.view removeFromSuperview];
    [self displayLoadingFinishedUI];
}

- (void)subscriberDidFail:(OTSubscriber *)subscriber error:(NSError *)error {
    [self displayMessage:@"Subscriber failed"];
    [self displayLoadingFinishedUI];
}


#pragma mark - Helper Methods

- (void)displayMessage:(NSString *)string {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:string preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

