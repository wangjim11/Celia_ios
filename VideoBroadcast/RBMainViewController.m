//
//  RBMainViewController.m
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/13/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import "RBMainViewController.h"
#import "RBPublisherViewController.h"
#import "RBSubscriberViewController.h"
#import "RBCameraCell.h"
#import "RBOPTSessionManager.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

#define CELL_IDENTIFIER     @"cellIdentifier"

@interface RBMainViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView   *cameraTableView;
@property (nonatomic, strong) NSArray       *cameraArray;
@property (nonatomic, strong) NSString      *sessionID;
@property (nonatomic, strong) NSString      *sessionToken;
@end

@implementation RBMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *addRoomItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewRobot)];
    self.navigationItem.rightBarButtonItem = addRoomItem;
    UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"Log out" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    self.navigationItem.leftBarButtonItem = logoutItem;
    
    _cameraTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.estimatedRowHeight = 60;
        [tableView registerClass:[RBCameraCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:tableView];
        
        NSDictionary *viewDict = @{@"table":tableView};
        NSArray *hCN = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[table]|" options:0 metrics:nil views:viewDict];
        [self.view addConstraints:hCN];
        NSArray *vCN = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[table]|" options:0 metrics:nil views:viewDict];
        [self.view addConstraints:vCN];
        
        tableView;
    });
    
    __weak RBMainViewController *weakSelf = self;
    [[RBOPTSessionManager sharedInstance] createOrFetchDefaultCamera:^(RBCamera *camera, NSError *error) {
        if (!error) {
            PFQuery *query = [PFQuery queryWithClassName:@"Camera"];
            [query whereKey:@"iosUID" notEqualTo:camera.iosUID];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                weakSelf.cameraArray = objects;
                [weakSelf.cameraTableView reloadData];
            }];
        }
    }];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    [[delegateFreeSession dataTaskWithURL:[NSURL URLWithString:@"https://yam-j-opentok.herokuapp.com/sessionid"]
                        completionHandler:^(NSData *data, NSURLResponse *response,
                                            NSError *error) {
                            /*
                            NSLog(@"Got response %@ with error %@.\n", response, error);
                            NSLog(@"DATA:\n%@\nEND DATA\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                             */
                            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                            NSArray *components = [string componentsSeparatedByString:@";"];
                            NSString *sessionString = [components objectAtIndex:0];
                            _sessionID = [[sessionString componentsSeparatedByString:@"="] objectAtIndex:1];
                            NSString *tokenString = [components objectAtIndex:1];
                            _sessionToken = [[tokenString componentsSeparatedByString:@"token= "] objectAtIndex:1];
                            NSLog(@"%@", _sessionID);
                            NSLog(@"%@", _sessionToken);
                            
                        }] resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_cameraArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RBCameraCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    cell.camera = [_cameraArray objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    

//    RBPublisherViewController *controller = [[RBPublisherViewController alloc] init];
//    [self.navigationController pushViewController:controller animated:YES];

    
    RBSubscriberViewController *controller = [[RBSubscriberViewController alloc] init];
    RBCamera *camera = [_cameraArray objectAtIndex:indexPath.row];
    camera.optSessionID = _sessionID;
    camera.optSessionToken = _sessionToken;
    [camera saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        controller.camera = camera;
        [self.navigationController pushViewController:controller animated:YES];
    }];
}


#pragma mark - Action Methods

- (void)addNewRobot {
    
}

- (void)logout {
    [PFUser logOut];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate updateRootViewController];
}

@end

