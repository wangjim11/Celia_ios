//
//  RBOPTSessionManager.m
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/13/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import "RBOPTSessionManager.h"
#import "RBCloudManager.h"
#import "RBUtilityManager.h"
#import "RBCamera.h"

#define OPENTOK_API_KEY     @"45499902"

@interface RBOPTSessionManager ()<OTSessionDelegate, OTPublisherDelegate, OTSubscriberDelegate>
@property (nonatomic, strong) NSString              *publisherSessionID;
@property (nonatomic, strong) OTSession             *publisherSession;
@property (nonatomic, strong) OTPublisher           *publisher;
@property (nonatomic, strong) OTSession             *subscriberSession;
@property (nonatomic, strong) OTSubscriber          *subscriber;
//@property (nonatomic, strong) NSTimer               *subscriberTimer;
@property (nonatomic, assign) BOOL                  showLogInfo;
@end

@implementation RBOPTSessionManager

+ (instancetype)sharedInstance {
    static RBOPTSessionManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RBOPTSessionManager alloc] initWithCamera:[RBCamera defaultCamera]];
    });
    return sharedInstance;
}

- (instancetype)initWithCamera:(RBCamera *)camera {
    self = [super init];
    if (self) {
        _publisherSessionID = [camera.optSessionID copy];
        _showLogInfo = YES;
    }
    return self;
}

- (BOOL)isPublishingStream {
    return _publisherSession!=nil && _publisher!=nil;
}

- (void)createOrFetchDefaultCamera:(void (^)(RBCamera *camera, NSError *error))completion {
    if ([RBCamera defaultCamera]) {
        completion([RBCamera defaultCamera], nil);
    }else{
        __weak RBOPTSessionManager *weakSelf = self;
        PFQuery *query = [PFQuery queryWithClassName:@"Camera"];
        [query whereKey:@"iosUID" equalTo:[[RBUtilityManager sharedInstance] deviceUID]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if ([objects count]) {
                RBCamera *camera = [objects objectAtIndex:0];
                [RBCamera setDefaultCamera:camera];
                weakSelf.publisherSessionID = [camera.optSessionID copy];
                completion(camera, error);
            }else{
                [RBCloudManager createCamera:^(RBCamera *camera, NSError *error) {
                    [RBCamera setDefaultCamera:camera];
                    completion(camera, error);
                }];
            }
        }];
    }
}


#pragma mark - Subscribe

- (void)subscribeToCamera:(RBCamera *)camera {
    if ([self isSubscribingToCamera:camera]) {
        return;
    }
    [self cleanSubscribingInfo];
    
    NSLog(@"id: %@", camera.optSessionID);
    NSLog(@"token: %@", camera.optSessionToken);
    
    _subscriberSession = [[OTSession alloc] initWithApiKey:OPENTOK_API_KEY
                                                 sessionId:camera.optSessionID
                                                  delegate:self];
    if (_subscriberSession) {
        NSError *sessionError = nil;
        [_subscriberSession connectWithToken:camera.optSessionToken error:&sessionError];
        if (sessionError) {
            NSLog(@"error: %@", sessionError);
        }
    }
    
//    [RBCloudManager createSubscriberTokenWithCamera:camera completed:^(NSString *newToken, NSError *error) {
//        NSLog(@"token %@", newToken);
//        if ([newToken length] && !error) {
//            [_subscriberSession connectWithToken:newToken error:nil];
//        }
//    }];
}

- (void)unsubscribeFromCamera:(RBCamera *)camera {
    if (![_subscriberSession.sessionId isEqualToString:camera.optSessionID]) {
        return;
    }
    
    [self cleanSubscribingInfo];
}

- (BOOL)isSubscribingToCamera:(RBCamera *)camera {
    return [camera.optSessionID isEqualToString:_subscriberSession.sessionId];
}

- (void)cleanSubscribingInfo {
//    [_subscriberTimer invalidate];
//    _subscriberTimer = nil;
    
    if ([_subscriber.view superview]) {
        [_subscriber.view removeFromSuperview];
    }
    _subscriber = nil;
    
    [_subscriberSession disconnect:nil];
    _subscriberSession = nil;
}


#pragma mark - Publish

- (void)publicLocalStream:(void(^)(OTPublisher *publisher, NSError *error))complete {
    [self cleanPublishingInfo];
    
    _publisherSession = [[OTSession alloc] initWithApiKey:OPENTOK_API_KEY
                                                sessionId:[_publisherSessionID copy]
                                                 delegate:self];
    __weak RBOPTSessionManager *weakSelf = self;
    [RBCloudManager createPublisherTokenWithCamera:[RBCamera defaultCamera] completed:^(NSString * newToken, NSError *error) {
        if ([newToken length] && !error) {
            NSError *connectionError = nil;
            [weakSelf.publisherSession connectWithToken:newToken error:&connectionError];
            if (complete && connectionError) {
                complete(nil, connectionError);
                return;
            }
            
            weakSelf.publisher = [[OTPublisher alloc] initWithDelegate:weakSelf name:[[UIDevice currentDevice] name]];
            if (complete) {
                complete(weakSelf.publisher, nil);
            }
        }else if (error){
            if (complete) {
                complete(nil, error);
            }
        }
    }];
}

- (void)unpublicLocalStream {
    [self cleanPublishingInfo];
}

- (BOOL)isPublishingLocalStream {
    return _publisher!=nil;
}

- (void)cleanPublishingInfo {
    if ([_publisher.view superview]) {
        [_publisher.view removeFromSuperview];
    }
    _publisher = nil;
    
    [_publisherSession disconnect:nil];
    _publisherSession = nil;
}


#pragma mark - OTSessionDelegate Methods

- (void)sessionDidConnect:(OTSession*)session {
    if (_showLogInfo) {
        NSLog(@"session did connect");
    }
    
    if ([session.sessionId isEqualToString:_publisherSession.sessionId]) {
        OTError *error = nil;
        [session publish:_publisher error:&error];
    }
}

- (void)sessionDidDisconnect:(OTSession *)session {
    if (_showLogInfo) {
        NSLog(@"session did disconnect");
    }
}

- (void)session:(OTSession *)session didFailWithError:(OTError *)error {
    if (_showLogInfo) {
        NSLog(@"session did fail with error: %@", error);
    }
    
    BOOL isPublishSession = [session.sessionId isEqualToString:_publisherSession.sessionId];
    BOOL isSubscriberSession = [session.sessionId isEqualToString:_subscriberSession.sessionId];
    
    if (isPublishSession && [self.publisherDelegate respondsToSelector:@selector(publishSessionDidFail:error:)]) {
        [self.publisherDelegate publishSessionDidFail:session error:error];
    }
    
    if (isSubscriberSession && [self.subscriberDelegate respondsToSelector:@selector(subscriberSessionDidFail:error:)]) {
        [self.subscriberDelegate subscriberSessionDidFail:session error:error];
    }
}

- (void)session:(OTSession *)session streamCreated:(OTStream *)stream {
    if (_showLogInfo) {
        if ([session.sessionId isEqualToString:_subscriberSession.sessionId]) {
            NSLog(@"session subscriber stream created");
        }else{
            NSLog(@"session publisher stream created");
        }
    }
    
    if ([session.sessionId isEqualToString:_subscriberSession.sessionId]) {
        _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
        
        OTError *error = nil;
        [session subscribe:_subscriber error:&error];
    }
}

- (void)session:(OTSession *)session streamDestroyed:(OTStream *)stream {
    if (_showLogInfo) {
        if ([session.sessionId isEqualToString:_subscriberSession.sessionId]) {
            NSLog(@"session subscriber stream destroyed");
        }else{
            NSLog(@"session publisher stream destroyed");
        }
    }
}

- (void)session:(OTSession *)session connectionCreated:(OTConnection *)connection {
    if (_showLogInfo) {
        if ([session.sessionId isEqualToString:_subscriberSession.sessionId]) {
            NSLog(@"session subscriber connection created");
        }else{
            NSLog(@"session publisher connection created");
        }
    }
}

- (void)session:(OTSession *)session connectionDestroyed:(OTConnection *)connection {
    if (_showLogInfo) {
        if ([session.sessionId isEqualToString:_subscriberSession.sessionId]) {
            NSLog(@"session subscriber connection destroyed");
        }else{
            NSLog(@"session publisher connection destroyed");
        }
    }
}

- (void)session:(OTSession *)session receivedSignalType:(NSString *)type fromConnection:(OTConnection *)connection withString:(NSString *)string {
    
}


#pragma mark - OTSubscriberDelegate Methods

- (void)subscriberDidConnectToStream:(OTSubscriberKit *)subscriber {
    if (_showLogInfo) {
        NSLog(@"subscriber did connect to stream");
    }
    
    if ([self.subscriberDelegate respondsToSelector:@selector(subscriberDidConnected:)]) {
        [self.subscriberDelegate subscriberDidConnected:_subscriber];
    }
}

- (void)subscriberVideoDataReceived:(OTSubscriber *)subscriber {
    //    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)subscriber:(OTSubscriberKit *)subscriber didFailWithError:(OTError*)error {
    if (_showLogInfo) {
        NSLog(@"subscriber did fail with error");
    }
    
    if ([self.subscriberDelegate respondsToSelector:@selector(subscriberDidFail:error:)]) {
        [self.subscriberDelegate subscriberDidFail:_subscriber error:error];
    }
}


#pragma mark - OTPublisherKitDelegate Methods

- (void)publisher:(OTPublisherKit *)publisher didFailWithError:(OTError *)error {
    if (_showLogInfo) {
        NSLog(@"publisher did fail with error: %@", error);
    }
    if ([publisher.session.sessionId isEqualToString:_publisherSession.sessionId] && [self.publisherDelegate respondsToSelector:@selector(publisherDidFail:error:)]) {
        [self.publisherDelegate publisherDidFail:_publisher error:error];
    }
}

- (void)publisher:(OTPublisherKit *)publisher streamCreated:(OTStream *)stream {
    if (_showLogInfo) {
        NSLog(@"publisher stream created");
    }
    if ([self.publisherDelegate respondsToSelector:@selector(publisherDidStartPublishing:)]) {
        [self.publisherDelegate publisherDidStartPublishing:_publisher];
    }
}

- (void)publisher:(OTPublisherKit *)publisher streamDestroyed:(OTStream *)stream {
    if (_showLogInfo) {
        NSLog(@"publisher stream destroyed");
    }
    
    if ([self.publisherDelegate respondsToSelector:@selector(publisherDidStopPublishing:)]) {
        [self.publisherDelegate publisherDidStopPublishing:_publisher];
    }
}

@end

