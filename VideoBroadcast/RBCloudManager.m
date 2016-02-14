//
//  RBCloudManager.m
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/13/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import "RBCloudManager.h"
#import "RBCamera.h"
#import <Parse/Parse.h>

@implementation RBCloudManager

+ (void)createPublisherTokenWithCamera:(RBCamera *)camera completed:(void(^)(NSString *newToken, NSError *error))complete {
    NSDictionary *param = @{@"camera":camera.objectId, @"isPublisher":@(NO)};
    [self createTokenWithParam:param completed:complete];
}

+ (void)createSubscriberTokenWithCamera:(RBCamera *)camera completed:(void(^)(NSString *newToken, NSError *error))complete {
    NSDictionary *param = @{@"camera":camera.objectId, @"isPublisher":@(NO)};
    [self createTokenWithParam:param completed:complete];
}

+ (void)createTokenWithParam:(NSDictionary *)param completed:(void(^)(NSString *newToken, NSError *error))complete {
    [PFCloud callFunctionInBackground:@"getOpentokToken" withParameters:param block:^(id object, NSError *error) {
        NSString *token = (NSString *)object;
        if ([token length] && !error) {
            complete(token, nil);
        }else{
            complete(nil, error);
        }
    }];
}

@end
