//
//  RBCamera.m
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/13/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import "RBCamera.h"

@implementation RBCamera
@dynamic name;
@dynamic address;
@dynamic iosUID;
@dynamic optSessionID;
@dynamic isAvailable;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Camera";
}

static RBCamera *_defaultCamera = nil;

+ (void)setDefaultCamera:(RBCamera *)camera {
    _defaultCamera = camera;
}

+ (RBCamera *)defaultCamera {
    return _defaultCamera;
}

+ (void)fetchCameraWithObjectId:(NSString *)objectId inBackgroundWithBlock:(void (^)(RBCamera *camera, NSError *error))completion {
    [[RBCamera objectWithoutDataWithObjectId:objectId] fetchInBackgroundWithBlock:^(id _Nullable object, NSError * _Nullable error) {
        if (completion) {
            completion(object, error);
        }
    }];
}

@end

