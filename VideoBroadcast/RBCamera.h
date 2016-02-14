//
//  RBCamera.h
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/13/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import <Parse/Parse.h>

@interface RBCamera : PFObject<PFSubclassing>
@property (nonatomic, strong, nonnull)  NSString    *name;
@property (nonatomic, strong, nullable) NSString    *address;
@property (nonatomic, strong, nullable) NSString    *iosUID;
@property (nonatomic, strong, nullable) NSString    *optSessionID;
@property (nonatomic, assign) BOOL on;
@property (nonatomic, assign) BOOL available;
@property (nonatomic, assign) BOOL activated;

+ (void)setDefaultCamera:(RBCamera * _Nullable)camera;
+ (RBCamera * _Nullable)defaultCamera;
+ (void)fetchCameraWithObjectId:(NSString * _Nonnull)objectId inBackgroundWithBlock:(void (^ _Nullable)(RBCamera * _Nullable camera, NSError * _Nullable error))completion;

@end
