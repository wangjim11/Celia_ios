//
//  RBOPTSessionManager.h
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/13/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenTok/OpenTok.h>
#import "RBCamera.h"

@protocol RBOpenTokPublisherDelegate <NSObject>
@optional
// publisher delegate methods
- (void)publishSessionDidFail:(OTSession * _Nonnull)session error:(NSError * _Nonnull)error;
- (void)publisherDidStartPublishing:(OTPublisher * _Nonnull)publisher;
- (void)publisherDidStopPublishing:(OTPublisher * _Nonnull)publisher;
- (void)publisherDidFail:(OTPublisher * _Nonnull)publisher error:(NSError * _Nonnull)error;
@end

@protocol RBOpenTokSubscriberDelegate <NSObject>
@optional
// subscriber delegate methods
- (void)subscriberSessionDidFail:(OTSession * _Nonnull)session error:(NSError * _Nonnull)error;
- (void)subscriberDidConnected:(OTSubscriber * _Nonnull)subscriber;
- (void)subscriberDidDisconnected:(OTSubscriber * _Nonnull)subscriber;
- (void)subscriberDidFail:(OTSubscriber * _Nonnull)subscriber error:(NSError * _Nonnull)error;
@end


@interface RBOPTSessionManager : NSObject
@property (nullable, nonatomic, assign) id<RBOpenTokPublisherDelegate>      publisherDelegate;
@property (nullable, nonatomic, assign) id<RBOpenTokSubscriberDelegate>     subscriberDelegate;

// Singleton
+ (nonnull instancetype)sharedInstance;
- (BOOL)isPublishingStream;
- (void)createOrFetchDefaultCamera:(void (^ _Nonnull)(RBCamera * _Nullable camera, NSError * _Nullable error))completion;

// Subscribe
- (void)subscribeToCamera:(RBCamera * _Nonnull)camera;
- (void)unsubscribeFromCamera:(RBCamera * _Nonnull)camera;
- (BOOL)isSubscribingToCamera:(RBCamera * _Nullable)camera;

// publish
- (void)publicLocalStream:(void(^ _Nullable)(OTPublisher * _Nonnull publisher, NSError *_Nullable error))complete;
- (void)unpublicLocalStream;
- (BOOL)isPublishingLocalStream;

@end
