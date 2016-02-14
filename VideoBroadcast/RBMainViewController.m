//
//  RBMainViewController.m
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/13/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import "RBMainViewController.h"
#import "RBCameraCell.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

#define CELL_IDENTIFIER     @"cellIdentifier"

@interface RBMainViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView   *cameraTableView;
@property (nonatomic, strong) NSArray       *cameraArray;
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
    return cell;
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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

