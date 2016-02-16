//
//  RBCloudManager.m
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/13/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import "RBCloudManager.h"
#import "RBUtilityManager.h"
#import "RBCamera.h"
#import <Parse/Parse.h>

@implementation RBCloudManager

+ (void)createCamera:(void(^)(RBCamera *camera, NSError *error))completion {
    NSString *deviceID = [[RBUtilityManager sharedInstance] deviceUID];
    NSDictionary *param = @{@"name":[UIDevice currentDevice].name, @"iosUID":deviceID};
    [PFCloud callFunctionInBackground:@"createCamera" withParameters:param block:^(id object, NSError *error) {
        if (error) {
            NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
        }
        
        if (completion) {
            completion(object, error);
        } 
    }];
}

+ (void)createPublisherTokenWithCamera:(RBCamera *)camera completed:(void(^)(NSString *newToken, NSError *error))complete {
    NSDictionary *param = @{@"camera":camera.objectId, @"isPublisher":@(YES)};
    [self createTokenWithParam:param completed:complete];
}

+ (void)createSubscriberTokenWithCamera:(RBCamera *)camera completed:(void(^)(NSString *newToken, NSError *error))complete {
    NSDictionary *param = @{@"camera":camera.objectId, @"isPublisher":@(NO)};
    [self createTokenWithParam:param completed:complete];
}

+ (void)createTokenWithParam:(NSDictionary *)param completed:(void(^)(NSString *newToken, NSError *error))complete {
    [PFCloud callFunctionInBackground:@"getOpentokToken" withParameters:param block:^(id object, NSError *error) {
        NSString *token = (NSString *)object;
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([token length] && !error) {
                complete(token, nil);
            }else{
                complete(nil, error);
            }
        });
    }];
}

@end
