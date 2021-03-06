//
//  AppDelegate.m
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/8/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import "AppDelegate.h"
#import "RBLogInViewController.h"
#import "RBMainViewController.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"ceW4aDXKeMQSWxAYrPUBFYNyJ8pGirg1Z111xRJE"
                  clientKey:@"SqM03rhGcleZq9IzQ1do8xH4aZtW34qtgJtaTyEN"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window.layer setMasksToBounds:YES];
    [self.window.layer setShouldRasterize:YES];
    [self.window.layer setRasterizationScale:[UIScreen mainScreen].scale];
    self.window.layer.opaque = YES;
    self.window.rootViewController = [self decideRootViewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Helper Methods

- (void)updateRootViewController {
    self.window.rootViewController = [self decideRootViewController];
}

- (UIViewController *)decideRootViewController {
    if (![PFUser currentUser]) {
        return [[RBLogInViewController alloc] init];
    }else{
        RBMainViewController *rootViewController = [[RBMainViewController alloc] init];
        return [[UINavigationController alloc] initWithRootViewController:rootViewController];
    }
    return nil;
}

@end

