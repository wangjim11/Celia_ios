//
//  RBCloudManager.h
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/13/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RBCamera;
@interface RBCloudManager : NSObject
+ (void)createCamera:(void(^ _Nonnull)(RBCamera * _Nullable camera, NSError * _Nullable error))completion;
+ (void)createPublisherTokenWithCamera:(RBCamera * _Nullable)camera completed:(void(^ _Nullable)(NSString * _Nullable newToken, NSError * _Nullable error))complete;
+ (void)createSubscriberTokenWithCamera:(RBCamera * _Nullable)camera completed:(void(^ _Nullable)(NSString * _Nullable newToken, NSError * _Nullable error))complete;

@end
