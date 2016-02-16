//
//  RBPublisherViewController.m
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/14/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import "RBPublisherViewController.h"
#import "RBLocalSessionManager.h"
#import "RBOPTSessionManager.h"
#import "RBCamera.h"

#import "UIView+ViewConstraints.h"

@interface RBPublisherViewController ()<RBOpenTokPublisherDelegate>
@property (nonatomic, strong) UIView                    *containerView;
@property (nonatomic, strong) UIView                    *localSessionView;
@property (nonatomic, strong) UIView                    *optSessionView;
@property (nonatomic, strong) UISwitch                  *optSwitch;
@property (nonatomic, strong) UIActivityIndicatorView   *optActivityIndicator;
@end

@implementation RBPublisherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Publisher";
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPublish)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    _containerView = ({
        UIView *aView = [[UIView alloc] initWithFrame:CGRectZero];
        aView.backgroundColor = [UIColor whiteColor];
        aView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:aView];
        [aView addConstraintsToFillSuperview];
        
        aView;
    });
    
    _optSessionView = ({
        UIView *aView = [[UIView alloc] initWithFrame:CGRectZero];
        aView.backgroundColor = [UIColor whiteColor];
        aView.translatesAutoresizingMaskIntoConstraints = NO;
        [_containerView addSubview:aView];
        [aView addConstraintsToFillSuperview];
        
        aView;
    });
    
    _localSessionView = ({
        UIView *aView = [[UIView alloc] initWithFrame:CGRectZero];
        aView.backgroundColor = [UIColor blackColor];
        aView.translatesAutoresizingMaskIntoConstraints = NO;
        [_containerView addSubview:aView];
        [aView addConstraintsToFillSuperview];
        
        aView;
    });
    
    _optSwitch = ({
        UISwitch *aSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        aSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        [aSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:aSwitch];
        
        NSLayoutConstraint *centerXCN = [NSLayoutConstraint constraintWithItem:aSwitch attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        [self.view addConstraint:centerXCN];
        
        NSLayoutConstraint *bottomCN = [NSLayoutConstraint constraintWithItem:aSwitch attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-50];
        [self.view addConstraint:bottomCN];
        
        aSwitch;
    });
    
    _optActivityIndicator = ({
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
    
    [self configureLocalSession];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startSession];
    [self showLocalSession];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopSession];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI Action Methods

- (void)switchValueChanged:(UISwitch *)aSwitch {
    RBCamera *camera = [RBCamera defaultCamera];
    if (camera.isAvailable!=aSwitch.isOn) {
        camera.isAvailable = aSwitch.isOn;
        [camera saveInBackground];
    }
    
    if (aSwitch.isOn) {
        [_optActivityIndicator startAnimating];
        [self hideLocalPreview];
        [self startSession];
    }else{
        [_optActivityIndicator stopAnimating];
        [self showLocalSession];
        [self stopSession];
    }
}

- (void)cancelPublish {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - OpenTok Session

- (void)startSession {
    RBCamera *defaultCamera = [RBCamera defaultCamera];
    if (!defaultCamera.isAvailable) {
        defaultCamera.isAvailable = YES;
        [defaultCamera saveInBackground];
    }
    
    __weak RBPublisherViewController *weakSelf = self;
    RBOPTSessionManager *sessionManager = [RBOPTSessionManager sharedInstance];
    sessionManager.publisherDelegate = self;
    [sessionManager publicLocalStream:^(OTPublisher *publisher, NSError *error) {
        [weakSelf.optSessionView addSubview:publisher.view];
        publisher.view.translatesAutoresizingMaskIntoConstraints = NO;
        [publisher.view addConstraintsToFillSuperview];
    }];
}

- (void)stopSession {
    [[RBOPTSessionManager sharedInstance] unpublicLocalStream];
}


#pragma mark - Local Session

- (void)configureLocalSession {
    [RBLocalSessionManager sharedInstance].localSessionView = _localSessionView;
    [[RBLocalSessionManager sharedInstance] prepare];
}

- (void)showLocalSession {
    _localSessionView.hidden = NO;
    [[RBLocalSessionManager sharedInstance] startRunning];
}

- (void)hideLocalPreview {
    _localSessionView.hidden = YES;
    [[RBLocalSessionManager sharedInstance] stopRunning];
}


#pragma mark - OpenTok Publisher Delegate Methods

- (void)publisherDidStartPublishing:(OTPublisher *)publisher {
    
}

- (void)publisherDidStopPublishing:(OTPublisher *)publisher {
    
}

- (void)publishSessionDidFail:(OTSession *)session error:(NSError *)error {
    
}

- (void)publisherDidFail:(OTPublisher *)publisher error:(NSError *)error {
    
}

@end

